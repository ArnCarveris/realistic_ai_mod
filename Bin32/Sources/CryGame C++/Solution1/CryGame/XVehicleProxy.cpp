
//////////////////////////////////////////////////////////////////////
//
//	Crytek Source code
//	Copyright (c) Crytek 2001-2004
//
//  File: XVehicleProxy.cpp
//  Description: AI vehicles proxy
//
//  History:
//  - Oct, 17, 2002: Created by Kirill Bulatsev
//	- February 2005: Modified by Marco Corbetta for SDK release
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "xvehicleproxy.h"
#include "XVehicle.h"
#include <IAISystem.h>

//////////////////////////////////////////////////////////////////////
CXVehicleProxy::CXVehicleProxy(IEntity *pEntity,IScriptSystem *pScriptSystem, CXGame *pGame):
pSignalTable(pScriptSystem),
m_MinAltitude(0.0f),
m_bTargetInWater(true)
{
	m_pScriptSystem = pScriptSystem;
	m_pEntity = pEntity;

	m_fThrust = 0;
	m_fTilt = 0;
	m_fAngle = 0;
	m_VertThrust = 0.0f;
	m_DeviationTime = 0.0f;
	m_Movement(0,0,0);
	m_Direction = pEntity->GetAngles();

	m_NotMovingTime = 0.0f;
	m_ReverseTime = 0.0f;
	DontBack = false;
	DontStop = false;
	LowForward = .0f;

	if (m_pEntity->GetContainer())
	{
		if (!m_pEntity->GetContainer()->QueryContainerInterface(CIT_IVEHICLE,(void**) &m_pVehicle))
			m_pVehicle = 0;
	}
	else
		m_pVehicle = 0;

	m_fBackwardSpeed = 0;
	m_fForwardSpeed = 0;
	m_pGame = pGame;

	m_AIHandler.Init( m_pGame, m_pEntity, m_pGame->GetSystem()->GetILog() );
}

//////////////////////////////////////////////////////////////////////
CXVehicleProxy::~CXVehicleProxy(void)
{
}

//////////////////////////////////////////////////////////////////////
int CXVehicleProxy::Update(SOBJECTSTATE *state)
{

	// FIXME - this should be done some other way - not to check for AI driver every time
	if(m_Type==AIOBJECT_HELICOPTER)		// no driver in hely
		MoveLikeAHelicopter( state );
	else
	{
		IEntity *driverEnt =0;
		if (m_pVehicle && m_Type)
			driverEnt = m_pGame->GetSystem()->GetIEntitySystem()->GetEntity(m_pVehicle->m_DriverID);

		if(driverEnt)
		{
			IAIObject * driveAI = driverEnt->GetAI();
			if(driveAI && driveAI->GetType() != AIOBJECT_PLAYER)
			{
				// fixme over
				switch(m_Type) {
				case AIOBJECT_HELICOPTER:
					MoveLikeAHelicopter( state );
					break;
				case AIOBJECT_CAR:
					MoveLikeACar( state );
					break;
				case AIOBJECT_BOAT:
					MoveLikeABoat( state );
					break;
				}
			}
		}
	}

	if (state->bReevaluate)
		UpdateMind(state);

	if (!(m_LastObjectState == *state))
	{
		m_LastObjectState = *state;
		UpdateMotor(state);
	}

	while (!state->vSignals.empty())
	{
		AISIGNAL sstruct = state->vSignals.back();
		state->vSignals.pop_back();
		int signal = sstruct.nSignal;
		const char *szText = sstruct.strText;
		IEntity* pSender= (IEntity*) sstruct.pSender;
		//const char *SenderName = pSender->GetName();
		//if (SenderName==NULL)
            //SenderName = "NoName";
        if (m_Type==AIOBJECT_HELICOPTER)
            m_pGame->GetSystem()->GetILog()->Log("\004 %s: SIGNAL: %s",m_pEntity->GetName(),szText); // �������, �������!

		SendSignal(signal,szText,pSender);
	}

	if (state->nAuxSignal)
	{
		SendAuxSignal(state->nAuxSignal,state->szAuxSignalText.c_str());
		if (m_Type==AIOBJECT_HELICOPTER)
            m_pGame->GetSystem()->GetILog()->Log("\004 %s: AUX SIGNAL: %s",m_pEntity->GetName(),state->szAuxSignalText.c_str()); // �������, �������!
		state->nAuxSignal = 0;
	}
	return 0;
}

//////////////////////////////////////////////////////////////////////
void CXVehicleProxy::UpdateMind(SOBJECTSTATE *state)
{
	m_AIHandler.AIMind( state );
	state->bReevaluate = false;
	return;
}

//////////////////////////////////////////////////////////////////////
int CXVehicleProxy::UpdateMotor(SOBJECTSTATE *state)
{
	return 0;
}

//////////////////////////////////////////////////////////////////////
void CXVehicleProxy::SendSignal(int signalID, const char * szText, IEntity *pSender)
{
	m_pEntity->SetNeedUpdate( true );
	m_AIHandler.AISignal( signalID, szText, pSender );
	return;
}

//////////////////////////////////////////////////////////////////////
void CXVehicleProxy::SendAuxSignal(int signalID, const char * szText)
{
	// clear normal stuff
	pSignalTable->SetValue("nSignal",0);
	pSignalTable->SetToNull("SignalText");

	pSignalTable->SetValue("nAuxSignal",signalID);
	pSignalTable->SetValue("AuxSignalText",szText);

//	m_pScriptSystem->BeginCall(m_pEntity->GetEntityClassName(),m_strSignalFuncName.c_str());
	m_pScriptSystem->BeginCall(m_hSignalFunc);
	m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
	m_pScriptSystem->PushFuncParam(*pSignalTable);
	m_pScriptSystem->EndCall();
}

//////////////////////////////////////////////////////////////////////
void CXVehicleProxy::SetSignalFunc(HSCRIPTFUNCTION pFunc)
{
	m_hSignalFunc.Init(m_pScriptSystem,pFunc);
}

//////////////////////////////////////////////////////////////////////
void CXVehicleProxy::SetBehaviourFunc(HSCRIPTFUNCTION pFunc)
{
	m_hBehaviourFunc.Init(m_pScriptSystem,pFunc);

}

//////////////////////////////////////////////////////////////////////
void CXVehicleProxy::SetMotorFunc(HSCRIPTFUNCTION pFunc)
{
	m_hMotorFunc.Init(m_pScriptSystem,pFunc);
}

//////////////////////////////////////////////////////////////////////
bool CXVehicleProxy::QueryProxy(unsigned char type, void **pProxy)
{
	if (type == AIPROXY_VEHICLE)
	{
		*pProxy = (void *) this;
		return true;
	}
	else
		return false;
}

//////////////////////////////////////////////////////////////////////
void CXVehicleProxy::MoveLikeAnAirplane(SOBJECTSTATE * state)
{
}

//////////////////////////////////////////////////////////////////////
void CXVehicleProxy::MoveLikeACar(SOBJECTSTATE * state)
{
	bool bSpecial;
	m_pEntity->GetScriptObject()->GetValue("OldDriving",bSpecial);
	if (!bSpecial)
    {
        //GetISystem()->GetILog()->Log("%s: NOT SPECIAL",m_pEntity->GetName());
        Vec3d angles = m_pEntity->GetAngles();
        Vec3d anglesMovement;
        CXEntityProcessingCmd tempCommand;
        float	frameTime = m_pGame->GetSystem()->GetITimer()->GetFrameTime();
        bool	doBreak = false;
        bool	doGoBack = false;
        bool	doGoBackReal = true;
        bool	bChasing = (state->bodystate==1);
        if(frameTime<=0.0f)
            frameTime = 0.01f;
        if(frameTime > .1f)
            frameTime = .1f;

        if( bChasing )	// update path always
        {
            Vec3	vClosestPoint;
            bool intersectsForbidden = true;
            if((state->vTargetPos.x+state->vTargetPos.y)!=0.0f)
                intersectsForbidden = m_pGame->GetSystem()->GetAISystem()->IntersectsForbidden(m_pEntity->GetPos(), state->vTargetPos, vClosestPoint);
            if(intersectsForbidden)
                m_pEntity->GetAI()->NeedsPathOutdoor(true, true);
            else
                m_pEntity->GetAI()->NeedsPathOutdoor(false, true);
            state->pathUsage = SOBJECTSTATE::PU_NewPathWanted;
        }

        Vec3d vCurVel; // ������� ��������.
        float	curVel;
        // Create a new status object.  The fields are initialized for us
        pe_status_dynamics status;
        // Get a pointer to the physics engine
        IPhysicalEntity *physEnt = m_pEntity->GetPhysics();
        // Get new player status from physics engine
        if (physEnt && physEnt->GetStatus(&status))
        {
            // Get our current velocity, default will be (0,0,0)
            vCurVel = (Vec3d)status.v;
            anglesMovement = -status.v.normalized();
        }
        curVel = vCurVel.len();
        Vec3d desired = state->vMoveDir;//(Vec3d)motion.dir;

        /*float	avoidRadius = curVel*.73f;
        if(avoidRadius > 0)
        {
            if(avoidRadius<8)
                avoidRadius = 8;
            if(avoidRadius>15)
                avoidRadius = 15;
            desired += CarAvoidCollision( avoidRadius )*7.0f;
            desired.Normalize();
        }*/

        float	avoidRadius = curVel*.73f;
        if(avoidRadius > 0)
        {
            if(avoidRadius<8)
            {
                avoidRadius = 8;
            }
            if(avoidRadius>15)
            {
                avoidRadius = 15;
            }
            desired += CarAvoidCollision( avoidRadius )*7.0f; // ����������� ��������� ��� ��������� � ������� ���������.
            desired.Normalize();
            //GetISystem()->GetILog()->Log("avoidRadius: %f, desired: %f",avoidRadius,desired);
        }

        //	avoid sticking
        if (GetLengthSquared(state->vMoveDir))
        {
            if( m_ReverseTime > 0 )
            {
                if(m_ReverseTime == 0.1f||m_ReverseTime == 0.3f||m_ReverseTime == 0.5f||m_ReverseTime == 0.7f||m_ReverseTime == 0.9f)
                    doBreak = true; // now stop ���������.
                else
                //if(m_ReverseTime >= 0.1f)
                    doGoBack = true; // back up �����.
                //else if(m_ReverseTime > 2.0f)
                //if(m_ReverseTime > 0.2f && m_ReverseTime <= 0.8f)

                /*else
                    doGoBackReal = false;
    */
                m_ReverseTime -= frameTime; // ������� ����� �� ����� �����.
                m_NotMovingTime = -0.3f; // -0.3f ��� ���-�� ��� ������ ����� �� ����.
            }
            else
            {
                //if( curVel < .3 )// && m_ReverseTime<=0 )
                if( curVel < 0.3f ) // .3 ���� �������� ������ x, ��...
                {
                    m_NotMovingTime += frameTime; // ����������� ����� ��� ��������.
                    //if(m_NotMovingTime>0.1f&&DontBack==false) // 1.0
                    if(m_NotMovingTime>0.1f&&DontBack==false) // 1.0
                    {
                        m_ReverseTime = 0.5f; // 1.9f ������� ������� ������� �����.
                        m_NotMovingTime = -0.3f;
                        DontStop = true;
                    }
                    /*if (DontBack==true)
                        GetISystem()->GetILog()->Log("DontBack==true");
                    else
                        GetISystem()->GetILog()->Log("DontBack==false");*/
                }
                else
                    m_NotMovingTime = 0.0f;
            }
        }
        else
            m_NotMovingTime = 0.0f;

        m_LastPos = m_pEntity->GetPos();

        // [filippo]: if there is no active target to go hold down the brake.
        // GetISystem()->GetILog()->Log("distance from target for %s : %.3f (%s) %i",m_pEntity->GetName(),state->fDistanceFromTarget,state->bTargetEnabled?"enable":"not enable",state->nTargetType);

        if (state->left || state->right || doBreak || (!state->bTargetEnabled /*&& state->fDistanceFromTarget<=0.0f*/))
        {
            tempCommand.AddAction(ACTION_WALK); // ���� ����� �����?
            //GetISystem()->GetILog()->Log("ACTION_WALK");
            m_NotMovingTime = -50.0f;

        }
        else // drive!!!
        {
            float crossz = desired.x * anglesMovement.y - desired.y *  anglesMovement.x;
            float	dotz = desired.x * anglesMovement.x + desired.y *  anglesMovement.y;

            if (state->back || doGoBack)
            {
                state->pathUsage = SOBJECTSTATE::PU_NewPathWanted;
                //if (doGoBackReal)
                    tempCommand.AddAction(ACTION_MOVE_BACKWARD);
                    //GetISystem()->GetILog()->Log("BACK");

                /*if( fabs(crossz) <= 0.1f  )
                {
                    GetISystem()->GetILog()->Log("fabs(crossz) <= 0.1f");
                    if( rand()%100<50 )
                        crossz = -1.0f;
                    else
                        crossz = 1.0f;
                }*/
            }
            else if (GetLengthSquared(state->vMoveDir))
            {
                //GetISystem()->GetILog()->Log("FORWARD");
                float	newSlowDwn = 1.0f;
                float	fMaxSpeed = 25.5f;
                // Create a new status object.  The fields are initialized for us
                pe_status_vehicle_abilities status_va;
                // Get new player status from physics engine
                    if (physEnt && physEnt->GetStatus(&status_va))
                        //fMaxSpeed = status_va.maxVelocity*.4f;	// physics returns not real value
                        fMaxSpeed = status_va.maxVelocity*.4f;	// physics returns not real value

                fMaxSpeed *= m_fForwardSpeed;

                float	scaleSlowDown = 1;
                float	MaxDistScaleSlowDown = 25.0f; //25.0f
                // ������ ��������� �������� � ������ ����� ����� ��������� � ������ �� �����, ���� �������� �� �����.
                if(state->fDistanceFromTarget < MaxDistScaleSlowDown)
                    //scaleSlowDown = 1.0f-( Ffabs(crossz) * 2.0f * (MaxDistScaleSlowDown-state->fDistanceFromTarget)/MaxDistScaleSlowDown);
                    scaleSlowDown = 1.0f-(Ffabs(crossz)*3.0f*(MaxDistScaleSlowDown-state->fDistanceFromTarget)/MaxDistScaleSlowDown);
                    //float scaleSlowDown2=scaleSlowDown;
               // else
                    //scaleSlowDown = 1.0f-(Ffabs(crossz))*2.0f;

                //float scaleSlowDown2 = scaleSlowDown;

                // If chasing and close to target - don't speed up
                if( state->fDistanceFromTarget<20 && bChasing ) // ��� �������������.
                {
                    newSlowDwn = state->fDistanceFromTarget/10.0f;
                    if( scaleSlowDown > newSlowDwn )
                        scaleSlowDown = newSlowDwn;
                }

                /*if(fabsf(status.w.z)>1.0f)	// too much of angular velocity - don't speed up ��� ���������.
                {
                    newSlowDwn = 1.0f - fabsf(status.w.z)/5.0f;
                    if( newSlowDwn<0.0f )
                        newSlowDwn = 0.0f;
                    if(scaleSlowDown > newSlowDwn)
                        scaleSlowDown = newSlowDwn;
                }*/

                if((fabsf(status.w.z)>1.0f&&(bSpecial||bChasing))||(bSpecial==false&&bChasing==false))	// too much of angular velocity - don't speed up ��� ���������.
                //if(fabsf(status.w.z)>1.0f)
                {
                    newSlowDwn = 1.0f - fabsf(status.w.z)/5.0f;
                    if( newSlowDwn<0.0f )
                        newSlowDwn = 0.0f;
                    if(scaleSlowDown > newSlowDwn)
                        scaleSlowDown = newSlowDwn;
                }

                if( scaleSlowDown < .7f ) //.7f
                    state->pathUsage = SOBJECTSTATE::PU_NewPathWanted;

                //if( scaleSlowDown < .2f )
                    //scaleSlowDown = .2f;

                if( scaleSlowDown <= .2f || curVel <= 0.3f )
                //if( scaleSlowDown2 <= .2f )
                {
                    //if (scaleSlowDown <= .2f)
                        LowForward += frameTime;
                    //if (LowForward > 0.5f && curVel <= 0.3f)
                    //if (LowForward > 0.5f)
                    //{
                        //GetISystem()->GetILog()->Log("scaleSlowDown = .2f");
                        scaleSlowDown = .2f;
                    //}
                   // else
                        //scaleSlowDown = .1f;

                    if (LowForward > 0.1f)
                    {
                        DontBack = false;
                    }
                    else
                        DontBack = true;
                }
                else
                {
                    //GetISystem()->GetILog()->Log("LowForward = .0f");
                    LowForward = .0f;
                    DontBack = false;
                }

                if( scaleSlowDown < .0f )
                    scaleSlowDown = .0f;

                if( state->fDesiredSpeed > scaleSlowDown )
                    state->fDesiredSpeed = scaleSlowDown;

                if(fMaxSpeed==1.0f || curVel < fMaxSpeed*state->fDesiredSpeed)
                {
                    // If chasing and close to target - don't speed up
                        tempCommand.AddAction(ACTION_MOVE_FORWARD);	// speed up
                }
                else
                {
                    if(state->fDesiredSpeed<.5f && curVel>1.0f && DontStop==false)
                        tempCommand.AddAction(ACTION_WALK);					// break
                    if (DontStop==true)
                        DontStop = false;
                }
            }

            if( curVel < 3 || fabsf(status.w.z)*curVel<30.0f )	// don't steer if too fast and have angular momentum already
            {
                //GetISystem()->GetILog()->Log("LEFT/RIGHT: %f",fabsf(status.w.z)*curVel);
                float omegaScale;
                //float	omegaScale = state->fDistanceFromTarget/50.0f;
                /*if(omegaScale>1.0f)
                    omegaScale = 1.0f;
                else if(omegaScale<0.1f)
                    omegaScale = 0.1f;*/
                omegaScale = 0.05f;

                float delta = 0.0f;
                if(dotz<0)
                    delta = .0051f;

                float curWZ = status.w.z;

                if (crossz < -delta)
                {
                    if((crossz < curWZ*omegaScale || curWZ>0) )
                    {
                        tempCommand.AddAction(ACTION_MOVE_RIGHT);
                        state->DEBUG_controlDirection = 1;
                    }
                }
                else if (crossz > delta)
                {
                    if((crossz > curWZ*omegaScale || curWZ<0))
                    {
                        tempCommand.AddAction(ACTION_MOVE_LEFT);
                        state->DEBUG_controlDirection = 2;
                    }
                }
            }
            else
                int amv=2;
        }

        if( curVel>0 && state->fDistanceFromTarget/curVel<3.0f )
            state->pathUsage = SOBJECTSTATE::PU_PathOK; // �� ������������ ����� ����, ����� �� �������.
        // don't regenerate path if too close to navTarget
        // coz can take too long to make new path
        pe_status_vehicle	vStatus;
        physEnt->GetStatus(&vStatus);
        if(vStatus.bWheelContact == 0)	// no wheels on ground - don't turn
        {
            tempCommand.RemoveAction(ACTION_MOVE_LEFT);
            tempCommand.RemoveAction(ACTION_MOVE_RIGHT);
        }
        m_pVehicle->ProcessMovement(tempCommand);
    }
    else
    {
        //GetISystem()->GetILog()->Log("%s: SPECIAL",m_pEntity->GetName());
        Vec3d angles = m_pEntity->GetAngles();
        Vec3d anglesMovement;
        CXEntityProcessingCmd tempCommand;
        float	frameTime = m_pGame->GetSystem()->GetITimer()->GetFrameTime();
        bool	doBreak = false;
        bool	doGoBack = false;
        bool	doGoBackReal = true;
        bool	bChasing = (state->bodystate==1);
        if(frameTime<=0.0f)
            frameTime = 0.01f;
        if(frameTime > .1f)
            frameTime = .1f;

        state->pathUsage = SOBJECTSTATE::PU_PathOK;

        if( bChasing )	// update path always
        {
            Vec3	vClosestPoint;
            bool intersectsForbidden = true;
            if((state->vTargetPos.x+state->vTargetPos.y)!=0.0f)
                intersectsForbidden = m_pGame->GetSystem()->GetAISystem()->IntersectsForbidden(m_pEntity->GetPos(), state->vTargetPos, vClosestPoint);
            if(intersectsForbidden)
                m_pEntity->GetAI()->NeedsPathOutdoor(true, true);
            else
                m_pEntity->GetAI()->NeedsPathOutdoor(false, true);
            state->pathUsage = SOBJECTSTATE::PU_NewPathWanted;
        }

        Vec3d vCurVel;
        float	curVel;
        // Create a new status object.  The fields are initialized for us
        pe_status_dynamics status;
        // Get a pointer to the physics engine
        IPhysicalEntity *physEnt = m_pEntity->GetPhysics();
        // Get new player status from physics engine
        if (physEnt && physEnt->GetStatus(&status))
        {
            // Get our current velocity, default will be (0,0,0)
            vCurVel = (Vec3d)status.v;
            anglesMovement = -status.v.normalized();
        }
        curVel = vCurVel.len();

        Vec3d desired = state->vMoveDir;//(Vec3d)motion.dir;
        float	avoidRadius = curVel*.73f;
        if(avoidRadius > 0)
        {
            if(avoidRadius<8)
                avoidRadius = 8;
            if(avoidRadius>15)
                avoidRadius = 15;
            desired += CarAvoidCollision( avoidRadius )*7.0f;
            desired.Normalize();
        }

        //	avoid sticking
        if (GetLengthSquared(state->vMoveDir))
        {
            if( m_ReverseTime > 0 )
            {
                if( m_ReverseTime > .12 )
                    doGoBack = true;				// back up
                else
                    doBreak = true;					// now stop
                m_ReverseTime -= frameTime;
                m_NotMovingTime = -0.3f;
            }
            else
            {
                if( curVel < .3 )// && m_ReverseTime<=0 )
                {
                    m_NotMovingTime += frameTime;
                    if( m_NotMovingTime>1.0 )
                    {
                        m_ReverseTime = 1.9f;
                        m_NotMovingTime = 0.0f;
                    }
                }
                else
                    m_NotMovingTime = 0.0f;
            }
        }
        else
            m_NotMovingTime = 0.0f;

        m_LastPos = m_pEntity->GetPos();

        // [filippo]: if there is no active target to go hold down the brake.
        // GetISystem()->GetILog()->Log("distance from target for %s : %.3f (%s) %i",m_pEntity->GetName(),state->fDistanceFromTarget,state->bTargetEnabled?"enable":"not enable",state->nTargetType);

        if (state->left || state->right || doBreak || (!state->bTargetEnabled /*&& state->fDistanceFromTarget<=0.0f*/))
        {
            tempCommand.AddAction(ACTION_WALK);
        }
        else								// drive!!!
        {
            float crossz = desired.x * anglesMovement.y - desired.y *  anglesMovement.x;
            float	dotz = desired.x * anglesMovement.x + desired.y *  anglesMovement.y;

            if (state->back || doGoBack)
            {
                tempCommand.AddAction(ACTION_MOVE_BACKWARD);
                if( fabs(crossz) <= 0.1f  )
                {
                    if( rand()%100<50 )
                        crossz = -1.0f;
                    else
                        crossz = 1.0f;
                }
            }
            else if (GetLengthSquared(state->vMoveDir))
            {
                float	newSlowDwn=1.0f;
                float	fMaxSpeed = 25.5f;
                // Create a new status object.  The fields are initialized for us
                pe_status_vehicle_abilities status_va;
                // Get new player status from physics engine
                    if (physEnt && physEnt->GetStatus(&status_va))
                        fMaxSpeed = status_va.maxVelocity*.4f;	// physics returns not real value

                fMaxSpeed *= m_fForwardSpeed;

                float	scaleSlowDown = 1;
                if(state->fDistanceFromTarget < 25)
                    scaleSlowDown = 1.0f-( Ffabs(crossz) * 2.0f * (25.0f-state->fDistanceFromTarget)/25.0f);

                // If chasing and close to target - don't speed up
                if( state->fDistanceFromTarget<20 && bChasing )
                {
                    newSlowDwn = state->fDistanceFromTarget/10.0f;
                    if( scaleSlowDown > newSlowDwn )
                        scaleSlowDown = newSlowDwn;
                }

                if(fabsf(status.w.z)>1.0f)	// too much of angular velocity - don't speed up
                {
                    newSlowDwn = 1.0f - fabsf(status.w.z)/5.0f;
                    if( newSlowDwn<0.0f )
                        newSlowDwn = 0.0f;
                    if(scaleSlowDown > newSlowDwn)
                        scaleSlowDown = newSlowDwn;
                }

                if( scaleSlowDown < .7f )
                    state->pathUsage = SOBJECTSTATE::PU_NewPathWanted;

                if( scaleSlowDown < .2f )
                    scaleSlowDown = .2f;

                if( state->fDesiredSpeed > scaleSlowDown )
                    state->fDesiredSpeed = scaleSlowDown;

                if(fMaxSpeed==1.0f || curVel < fMaxSpeed*state->fDesiredSpeed)
                {
                    // If chasing and close to target - don't speed up
                        tempCommand.AddAction(ACTION_MOVE_FORWARD);	// speed up
                }
                else
                    if(state->fDesiredSpeed<.5f && curVel>1.0f)
                        tempCommand.AddAction(ACTION_WALK);					// break
            }

            if( curVel < 3 || fabsf(status.w.z)*curVel<30.0f )	// don't steer if too fast and have angular momentum already
            {

                float	omegaScale = state->fDistanceFromTarget/50.0f;
                if(omegaScale>1.0f)
                    omegaScale = 1.0f;
                else if(omegaScale<0.1f)
                    omegaScale = 0.1f;
                omegaScale = 0.05f;

                float delta = 0.0f;
                if(dotz<0)
                    delta = .0051f;

                float curWZ = status.w.z;

                if (crossz < -delta)
                {
                    if((crossz < curWZ*omegaScale || curWZ>0) )
                    {
                        tempCommand.AddAction(ACTION_MOVE_RIGHT);
                        state->DEBUG_controlDirection = 1;
                    }
                }
                else if (crossz > delta)
                {
                    if((crossz > curWZ*omegaScale || curWZ<0))
                    {
                        tempCommand.AddAction(ACTION_MOVE_LEFT);
                        state->DEBUG_controlDirection = 2;
                    }
                }
            }
            else
                int amv=2;
        }

        if( curVel>0 && state->fDistanceFromTarget/curVel<3.0f )
            state->pathUsage = SOBJECTSTATE::PU_PathOK;
        // don't regenerate path if too close to navTarget
        // coz can take too long to make new path
        pe_status_vehicle	vStatus;
        physEnt->GetStatus(&vStatus);
        if(vStatus.bWheelContact == 0)	// no wheels on ground - don't turn
        {
            tempCommand.RemoveAction(ACTION_MOVE_LEFT);
            tempCommand.RemoveAction(ACTION_MOVE_RIGHT);
        }
        m_pVehicle->ProcessMovement(tempCommand);
    }
}

//////////////////////////////////////////////////////////////////////
void CXVehicleProxy::MoveLikeABoat(SOBJECTSTATE * state)
{
	bool	bApproachingDropPoint=state->left||state->right;	// if strafing - means we are dropping people
	bool	bAttacking = (state->fStickDist>0.0f);
	bool	bTargetOnLand = (state->bodystate==1);
	Vec3d desired = state->vMoveDir;//(Vec3d)motion.dir;

	bool	bWantToMove = (desired.len2()!=0);
		desired += BoatAvoidCollision( 25.0f )*60.0f;
		desired.Normalize();
	bool	bWantToAvoidCollision = (desired.len2()!=0);

	Vec3d angles = m_pEntity->GetAngles();
	Vec3d vFwd;
	CXEntityProcessingCmd tempCommand;
	float	frameTime = m_pGame->GetSystem()->GetITimer()->GetFrameTime();
		if(frameTime > .1f)
			frameTime = 0.1f;

	Vec3d	vCurVel=Vec3d(0,0,0);
	float	fCurVel=0.0f;
	float	curWZ=0.0f;
	// Create a new status object.  The fields are initialized for us
	pe_status_dynamics status;
	// Get a pointer to the physics engine
	IPhysicalEntity *physEnt = m_pEntity->GetPhysics();
	// Get new player status from physics engine
	if (physEnt && physEnt->GetStatus(&status))
	{
		// Get our current velocity, default will be (0,0,0)
		vCurVel = (Vec3d)status.v;
		fCurVel = vCurVel.len();
		curWZ = status.w.z;
	}

	Matrix44 m;
	m.SetIdentity();

	//m.RotateMatrix_fix(angles);
	m=Matrix44::CreateRotationZYX(-angles*gf_DEGTORAD)*m; //NOTE: angles in radians and negated

	angles = m.TransformPointOLD(Vec3d(0,-1,0));
	angles.z=0;
	vFwd = angles;

	state->pathUsage = SOBJECTSTATE::PU_NewPathWanted;

	// send a signal if target (player) goes from water to land
	if( !BoatPointInWater(state->vTargetPos) )
	{
		if(m_bTargetInWater)
		{
			m_bTargetInWater = false;
			SendSignal(0, "TARGET_ON_LAND", m_pEntity);
		}
	}
	else
		m_bTargetInWater = true;

	// drive!!!
	{

	bool	doGoBack = false;
	bool	doBreak = false;

		//	avoid stucking
		if (bWantToMove)
		{
			if( m_ReverseTime > 0 )
			{
				doGoBack = true;				// back up
				m_ReverseTime -= frameTime;
				m_NotMovingTime = -0.5f;
			}
			else
			{
				if( fCurVel < .03 && !bAttacking)
				{
					m_NotMovingTime += frameTime;
					if( m_NotMovingTime>.31 )
					{
						m_ReverseTime = 1.62f;
						m_NotMovingTime = 0.0f;
					}
				}
				else
					m_NotMovingTime = 0.0f;
			}
		}
		else
			m_NotMovingTime = 0.0f;

		m_LastPos = m_pEntity->GetPos();
		Vec3d	actualDir = -vCurVel;
		actualDir.z=0;
		actualDir.normalize();
		angles = angles+actualDir*.5f;
		angles.normalize();

		float crossz = desired.x * angles.y - desired.y *  angles.x;
		float	dotz = desired.x * angles.x + desired.y *  angles.y;

		if (state->back || doGoBack )
		{
			tempCommand.AddAction(ACTION_MOVE_BACKWARD);
			if( crossz == 0.1f  )
			{
				if( rand()%100<50 )
					crossz = -1.0f;
				else
					crossz = 1.0f;
			}
			else
			{
				if( crossz < 0.0f )
					crossz = 1.0f;
				else
					crossz = -1.0f;
			}
		}
		else if (bWantToMove||bWantToAvoidCollision)
			tempCommand.AddAction(ACTION_MOVE_FORWARD);

		float targetCone = state->fDistanceFromTarget*0.32f/15.0f;
		if(targetCone>0.20f)
			targetCone = 0.20f;
		if(targetCone<0.05f)
			targetCone = 0.05f;

		float	omegaScale = state->fDistanceFromTarget/50.0f;
		if(omegaScale>1.0f)
			omegaScale = 1.0f;
		else if(omegaScale<0.1f)
			omegaScale = 0.1f;

		if(dotz>0.0f)
		{
			targetCone = 0.0f;
			omegaScale = 0.0f;
		}

		if(!bWantToMove)	// not moving - just turn to look at target
		{
			if(state->fValue<-.35f && (state->fValue < curWZ || curWZ>0) )
			{
				tempCommand.AddAction(ACTION_MOVE_RIGHT);
				state->DEBUG_controlDirection = 1;
				tempCommand.AddAction(ACTION_MOVEMODE);	// to enable turning without any speed
			}
			else if(state->fValue>.35f && (state->fValue > curWZ || curWZ<0) )
			{
				tempCommand.AddAction(ACTION_MOVE_LEFT);
				state->DEBUG_controlDirection = 2;
				tempCommand.AddAction(ACTION_MOVEMODE);	// to enable turning without any speed
			}
		} else			// normal turning when moving
		{
			if (crossz < -targetCone )
			{
				if((crossz < curWZ*omegaScale || curWZ>0) )
				{
					tempCommand.AddAction(ACTION_MOVE_RIGHT);
					state->DEBUG_controlDirection = 1;
				}
			}
			else if (crossz > targetCone )
			{
				if((crossz > curWZ*omegaScale || curWZ<0))
				{
					tempCommand.AddAction(ACTION_MOVE_LEFT);
					state->DEBUG_controlDirection = 2;
				}
			}
		}

		float	needToSlow = fCurVel*(float)(fabs(crossz)/state->fDistanceFromTarget);

		if ( bAttacking )
		// sticking - don't go too close to target
		{
			{
				if(state->fDistanceFromTarget<state->fStickDist && !bWantToAvoidCollision)
				{
				float	spidDistCoeff = state->fDistanceFromTarget/state->fStickDist;

					tempCommand.RemoveAction( ACTION_MOVE_FORWARD );

					if(spidDistCoeff>.6 && fCurVel>spidDistCoeff*5.1 )
					{
						tempCommand.AddAction( ACTION_WALK );			// break
					}
				}

				//slow down if diff dir
				float allowedSpeed=50;

				if(dotz>0)
				{
					allowedSpeed = 5.2f - (1-fabsf(crossz))*3;
					if( curWZ > 1.1f)			// don't add turn if angular speed is big already
					{
						tempCommand.RemoveAction(ACTION_MOVE_LEFT);
						tempCommand.RemoveAction(ACTION_MOVE_RIGHT);
					}
					else if( curWZ < -1.1f )
					{
						tempCommand.RemoveAction(ACTION_MOVE_LEFT);
						tempCommand.RemoveAction(ACTION_MOVE_RIGHT);
					}

				}
				else if( fabsf(crossz)>.5f )
					allowedSpeed = 10.2f - (fabsf(crossz))*2;

				if( fCurVel>allowedSpeed )
				{
					tempCommand.RemoveAction( ACTION_MOVE_FORWARD );
					tempCommand.RemoveAction( ACTION_MOVE_BACKWARD );
					if(allowedSpeed<5)
						tempCommand.AddAction( ACTION_WALK );			// break
					tempCommand.AddAction( ACTION_MOVEMODE );		// allow turning without movement
				}

				if( curWZ > 2 && fCurVel>.5f)	// don't add turn if angular speed is big already
				{
					tempCommand.RemoveAction(ACTION_MOVE_LEFT);
					tempCommand.RemoveAction(ACTION_MOVE_RIGHT);
				}
				else if( curWZ < -3 )
				{
					tempCommand.RemoveAction(ACTION_MOVE_LEFT);
					tempCommand.RemoveAction(ACTION_MOVE_RIGHT);
				}
			}
		}
		else if (bApproachingDropPoint && (fCurVel>7.5f || fCurVel*.70f > state->fDistanceFromTarget) )
		// slow down!!! coz have to stop at target
		{
			if(dotz<0.0f)	// if moving towards target
			{
				tempCommand.RemoveAction( ACTION_MOVE_FORWARD );
				if( fCurVel*0.5f > state->fDistanceFromTarget)
					tempCommand.AddAction(ACTION_MOVE_BACKWARD);
			}

		}
		else if(fabs(crossz)>.3f && fCurVel>7 && needToSlow>.2f  )
		// slow down!!! coz too close to target and going to miss it
		{
			tempCommand.RemoveAction( ACTION_MOVE_FORWARD );
			if( fCurVel*1.0f > state->fDistanceFromTarget)
				tempCommand.AddAction(ACTION_MOVE_BACKWARD);
		}

		// avoid going into land, except when is too slow or dropping people
		if(!bApproachingDropPoint)
		{
		Vec3d fwdPoint;
			if(fCurVel>.05f)
			{
				float scale = fCurVel*0.3f + 5.0f;
				if( scale>13 )
					scale = 13;
				fwdPoint = m_pEntity->GetPos() - actualDir*scale;
			}
			else
			{
				vFwd.normalize();
				fwdPoint = m_pEntity->GetPos() - vFwd*5;
			}

			Vec3d vClosestPoint;
			bool intersectsForbidden = m_pGame->GetSystem()->GetAISystem()->IntersectsForbidden(m_pEntity->GetPos(), fwdPoint, vClosestPoint)
										&& m_pEntity->GetAI()->IfNeedsPathOutdoor();

			// check for running into land and crossing forbidden area for some forwardPoint
			// in direction of movement, depending on cur velocity
			if( !BoatPointInWater(fwdPoint) || intersectsForbidden )
			{
				if(bAttacking)
				{
					if(dotz<0)	// target in front
						m_ReverseTime = 1 + (1+dotz);	// back off more if niids to turn for target
					else
						m_ReverseTime = 1;	// back off more if needs to turn for target

					m_ReverseTime = 0;
				}
				// can hit ground/forbidden area
				// enable turning without moving
				tempCommand.AddAction(ACTION_MOVEMODE2);
				tempCommand.AddAction(ACTION_MOVEMODE);
			}
		}
	}

	if(bTargetOnLand)
		m_pVehicle->ProcessMovementBoat2(tempCommand, m_fForwardSpeed*.3f);
	else
		m_pVehicle->ProcessMovementBoat2(tempCommand, m_fForwardSpeed);

	// disable pathfind with
	// AI:PushGoal(".....","strafe",0,-1);
	if(state->right)
		state->pathUsage = SOBJECTSTATE::PU_NoPathfind;
}

//////////////////////////////////////////////////////////////////////
void CXVehicleProxy::SetSpeeds(float fwd, float bkw)
{
	if( fwd >= 0 )
		m_fForwardSpeed = fwd;
	if( bkw >= 0 )
		m_fBackwardSpeed = bkw;
}

//////////////////////////////////////////////////////////////////////
// avoiding rockets
Vec3d CXVehicleProxy::UpdateThreat( void* threat )
{
	switch(m_Type) {
	case AIOBJECT_HELICOPTER:
		return UpdateThreatHeli( threat );
	case AIOBJECT_CAR:
		return UpdateThreatCar( threat );
	}
	return Vec3d(0,0,0);
}

//////////////////////////////////////////////////////////////////////
// avoiding rockets car
Vec3d CXVehicleProxy::UpdateThreatCar( void* threat )
{
IEntity* theThreatingEntity = (IEntity*)threat;

	if(!theThreatingEntity)
		return Vec3d(0,0,0);

	Vec3d dir = m_pEntity->GetPos() - theThreatingEntity->GetPos();
	float	dist = GetLengthSquared(dir);

	Vec3d threatVel = Vec3d(0,0,0);
	// Create a new status object.  The fields are initialized for us
	pe_status_dynamics status;
	// Get a pointer to the physics engine
	IPhysicalEntity *physEnt = theThreatingEntity->GetPhysics();
	// Get new player status from physics engine
	if (physEnt && physEnt->GetStatus(&status))
		// Get our current velocity, default will be (0,0,0)
		threatVel = (Vec3d)status.v;

	float	tDot = dir.Dot( threatVel );

	dir.Normalize();
	return dir;
}

//////////////////////////////////////////////////////////////////////
void CXVehicleProxy::DebugDraw(struct IRenderer * pRenderer)
{
}

//////////////////////////////////////////////////////////////////////
bool CXVehicleProxy::BoatPointInWater( const Vec3d& pos )
{

	float diff = m_pGame->m_p3DEngine->GetWaterLevel( &pos ) - m_pGame->m_p3DEngine->GetTerrainElevation( pos.x, pos.y );
	// see if target is on land or in water
	if( m_pGame->m_p3DEngine->GetWaterLevel( &pos ) -
		m_pGame->m_p3DEngine->GetTerrainElevation( pos.x, pos.y ) > .3f )
		return true;	// point in water

	return false;		// point on land or not deep
}

//////////////////////////////////////////////////////////////////////
Vec3d CXVehicleProxy::BoatFindAttackPoint( const Vec3d& targetPos )
{
	Vec3d	groundPos=targetPos;
	Vec3d	waterPos=m_pEntity->GetPos();

	return waterPos;

	for( int cntr=0; cntr<2; cntr++ )
	{
	Vec3d nextPos = (groundPos+waterPos)*.5;
		if( BoatPointInWater(nextPos) )
			waterPos = nextPos;
		else
			groundPos = nextPos;
	}
	return waterPos;
}

