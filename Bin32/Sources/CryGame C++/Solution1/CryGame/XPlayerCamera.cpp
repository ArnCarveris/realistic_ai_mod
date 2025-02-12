
//////////////////////////////////////////////////////////////////////
//
//	Crytek Source code
//	Copyright (c) Crytek 2001-2004
//
//  File: XPlayerCamera.cpp
//  Description: Entity Camera class.
//
//  History:
//  - August 16, 2001: Created by Petar and Alberto
//	- October 21,2002: Created by splitting Xplayer.cpp in multiple files
//	- Taken over by Anton Knyazyev
//	- February 2005: Modified by Marco Corbetta for SDK release
//
//////////////////////////////////////////////////////////////////////////

#include "StdAfx.h"
#include "XPlayer.h"
#include "XVehicle.h"
#include "WeaponClass.h"
#include "WeaponSystemEx.h"
#include <float.h>

//////////////////////////////////////////////////////////////////////////
/*! Updates the lean angles
*/
void CPlayer::UpdateLean()
{
	IEntityCamera *camera = m_pEntity->GetCamera();
	if (!camera)
		return;

	FUNCTION_PROFILER( GetISystem(),PROFILE_GAME );

	float frameTime = m_pGame->GetSystem()->GetITimer()->GetFrameTime();

	IPhysicalEntity *physEnt = m_pEntity->GetPhysics();
	if (physEnt)
	{
		//get view physics status
		pe_status_living status;
		if(physEnt->GetStatus(&status))
		{
			status.camOffset += vectorf(m_walkParams.shakeLOffset);
			camera->SetCamOffset(status.camOffset);//Vec3d(0, 0, status.eye_height));
		}
	}

	m_vEyeAngles=m_pEntity->GetAngles() + m_walkParams.shakeAOffset;// + m_vEyeAnglesBaseOffset;

	if((IsMyPlayer()||(m_bIsAI&&IsMyPlayer())) && (IsLeaning() || m_walkParams.fCurrLean!=0)) // ���������� �������. �� �����, ��� � ��� ��������.
	{
		// calculate if we would intersect with something during leaning....
		float fLeanTarget = IsLeaning() ? m_walkParams.fLeanTarget : m_walkParams.fCurrLean;
		Vec3d MaxLeanPos = CalcLeanOffset((fLeanTarget<0.0f ? -1.3f : 1.3f));
		Vec3d NormalPos=m_pEntity->GetPos()+camera->GetCamOffset();
		Vec3d	leanDir = MaxLeanPos - NormalPos;
		IPhysicalEntity *skip = m_pEntity->GetPhysics();
		ray_hit hits[1];
		//int flags = rwi_stop_at_pierceable;
		int flags = rwi_stop_at_pierceable | geom_colltype_player<<rwi_colltype_bit;
		int	goesInside=m_pPhysicalWorld->RayWorldIntersection(NormalPos,leanDir, ent_all, flags,hits,1, skip );
		if( goesInside==0 )
		{	// check if there is something in front of me
			float clipDist = camera->GetCamera().GetZMin();
			Vec3d PlayerDir=m_pEntity->GetAngles();

			Vec3d dir(0,-1,0);
			Matrix44 tm = Matrix44::CreateRotationZYX(-PlayerDir*gf_DEGTORAD); //NOTE: angles in radians and negated
			dir = GetTransposed44(tm)*(dir);

			//PlayerDir=ConvertToRadAngles(PlayerDir);
			PlayerDir=dir;

			PlayerDir.Normalize();
			PlayerDir *= clipDist*1.8f; // was 5
			goesInside=m_pPhysicalWorld->RayWorldIntersection(MaxLeanPos,PlayerDir, ent_all, flags,hits,1, skip );
			// also check 'the diagonal' - ray from head to the final test point, to avoid 'hooks' around corners
			goesInside += m_pPhysicalWorld->RayWorldIntersection(NormalPos,MaxLeanPos-NormalPos+PlayerDir, ent_all, flags,hits,1, skip );
		}

		if(goesInside || m_pMountedWeapon)	// stop leaning - go inside of something
		{
			m_walkParams.leanStart=m_walkParams.leanAmount;
			m_walkParams.leanEnd=0.0f;
			m_walkParams.leanFactor=0.0f;

			m_walkParams.fLeanTarget=0;
			if (!IsLeaning())
				m_walkParams.fCurrLean=0; // if we animate leaning to 0 and encounter an obstacle, just set 0 instantly
		}
	}

	if (/*IsLeaning( )*/(m_walkParams.fLeanTarget-m_walkParams.fCurrLean!=0) && (IsMyPlayer()||(m_bIsAI&&IsMyPlayer())))
	{

		float fMul=(m_walkParams.fLeanTarget-m_walkParams.fCurrLean>0) ? 1.0f : -1.0f;
		float fDiff=(float)fabs((10+m_walkParams.fLeanTarget)-(10+m_walkParams.fCurrLean));

		if(m_walkParams.fLeanTarget==0)
		{
			m_walkParams.fCurrLean+=m_walkParams.fCurrLean<0?min(m_pTimer->GetFrameTime()*(fMul*m_walkParams.leanSpeed*3),fDiff*fMul):max(m_pTimer->GetFrameTime()*(fMul*m_walkParams.leanSpeed*3),fDiff*fMul);
		}
		else
		{
			m_walkParams.fCurrLean+=m_walkParams.fLeanTarget>0?min(m_pTimer->GetFrameTime()*(fMul*m_walkParams.leanSpeed*3),fDiff*fMul):max(m_pTimer->GetFrameTime()*(fMul*m_walkParams.leanSpeed*3),fDiff*fMul);
		}
		//CLIP TO ! BYTE PRECISION
		int temp=(int)((m_walkParams.fCurrLean)/(1.f/255));
		m_walkParams.fCurrLean=(float)((temp)*(1.f/255));
	}

	float fAngle=m_walkParams.fCurrLean*m_LeanDegree;
	m_vEyeAngles.y+=fAngle;

	// � ��� � ��� ����� ---
    /*Vec3d bPos = m_pBoneHead->GetBonePosition();
    Matrix44 mat=Matrix44::CreateRotationZYX(-m_pEntity->GetAngles()*gf_DEGTORAD); //NOTE: angles in radians and negated
    bPos = mat.TransformPointOLD(bPos);
    m_vEyePos = bPos + m_pEntity->GetPos();*/

    /*Vec3d bPos = pWpnEye->GetBonePosition();
    Matrix44 mat=Matrix44::CreateRotationZYX(-m_pEntity->GetAngles()*gf_DEGTORAD); //NOTE: angles in radians and negated
    bPos = mat.TransformPointOLD(bPos);
    return bPos + m_pMountedWeapon->GetPos();*/
	/*if (!m_pBoneHead)
		return;

	Vec3d bPos = m_pBoneHead->GetBonePosition();
	Matrix44 mat;

	mat=Matrix44::CreateRotationZYX(-m_pEntity->GetAngles()*gf_DEGTORAD); //NOTE: angles in radians and negated
    if (AiCam==true) //���� ������� ��� �����.
        bPos = mat.TransformPointOLD(bPos);
	m_vEyePos = bPos + m_pEntity->GetPos();*/
}

//////////////////////////////////////////////////////////////////////////
Vec3d CPlayer::CalcLeanOffset(float leanAngle)
{
	IEntityCamera *camera = m_pEntity->GetCamera();
	if (!camera)
		return Vec3d(0,0,0);
	// when gunner in vehicle - no lean, take into account parent's matrix when adding camera offset
	if( m_pVehicle && m_stats.inVehicleState == PVS_GUNNER )
	{
		Matrix33 VehicleMat = Matrix33::CreateRotationXYZ( m_pVehicle->m_pEntity->GetAngles()*gf_DEGTORAD );
		pe_player_dimensions	dim;
		m_pEntity->GetPhysics()->GetParams( &dim );
		Vec3	offset(0.0f,0.0f,dim.heightEye);
		Vec3d	angl=m_pEntity->GetAngles(1);
		Matrix33 SelfMat = Matrix33::CreateRotationXYZ( Vec3d(0,0,angl.z*gf_DEGTORAD) );

		// here we offset camera a bit back from weapon (depending on up angle (angl.x))
		// to prevent intersection with weapon
		angl.x = Snap_s180(angl.x);
		offset.y = 1.5f*fabs( angl.x )/60.0f;
		if(offset.y > 1.5f)
			offset.y = 1.5f;
		offset = (VehicleMat*SelfMat)*offset;
		Vec3 NormalPos=m_pEntity->GetPos()+offset;
		return NormalPos;
	}

	// if using mounted weapon - try to get camera position from "eyes" bone of weapon
	if(m_pMountedWeapon)
	{
		ICryCharInstance *pChar = m_pMountedWeapon->GetCharInterface()->GetCharacter(0);
		if(pChar)
		{
			ICryBone* pWpnEye=pChar->GetBoneByName("eyes");
			if(pWpnEye)
			{
				Vec3d bPos = pWpnEye->GetBonePosition();
				Matrix44 mat=Matrix44::CreateRotationZYX(-m_pEntity->GetAngles()*gf_DEGTORAD); //NOTE: angles in radians and negated
				bPos = mat.TransformPointOLD(bPos);
				return bPos + m_pMountedWeapon->GetPos();
			}
		}
	}

	Vec3d PlayerDir=m_pEntity->GetAngles();
	PlayerDir=ConvertToRadAngles(PlayerDir);
	PlayerDir.Normalize();
	Vec3d Top(0.0f, 0.0f, 1.0f);
	Vec3d Tangent=PlayerDir.Cross(Top);
	Vec3d offset=camera->GetCamOffset();

	IPhysicalEntity *physEnt = m_pEntity->GetPhysics();
	if (physEnt)
	{
		pe_status_living status;
		if (physEnt->GetStatus(&status))
		{
		}
	}

	Vec3d NormalPos=m_pEntity->GetPos() + offset;
	Vec3d LeanOffset=Tangent*(-leanAngle*m_pGame->p_lean_offset->GetFVal());
	LeanOffset.z -= fabsf(leanAngle*m_pGame->p_lean_offset->GetFVal())*.36f;

	return NormalPos+LeanOffset;
}

//////////////////////////////////////////////////////////////////////////
bool CPlayer::IsLeaning( )
{
	return (m_walkParams.leanEnd!=m_walkParams.leanStart) || (m_walkParams.leanFactor);
}

//////////////////////////////////////////////////////////////////////////
// Updates the camera associated with the player
void CPlayer::UpdateCamera()
{
	IEntityCamera *camera = m_pEntity->GetCamera();
	if (!camera)
		return;

	FUNCTION_PROFILER( GetISystem(),PROFILE_GAME );

	if (!IsMyPlayer() && !m_pGame->IsMultiplayer()) //������� ������ ����. �� ������!
	{
		camera->SetPos(m_pEntity->GetPos());
		return;
	}

	float frameTime = m_pGame->GetSystem()->GetITimer()->GetFrameTime();

	IPhysicalEntity *physEnt = m_pEntity->GetPhysics();
	if (physEnt)
	{
		//get view physics status
		pe_status_living status;
		if (physEnt->GetStatus(&status))
		{
			status.camOffset += vectorf(m_walkParams.shakeLOffset);
			camera->SetCamOffset(status.camOffset);//Vec3d(0, 0, status.eye_height));
		}

	}

	//	if (IsAlive())
	{
		m_ValidPos = m_pEntity->GetPos();
		m_ValidPos.z += .2f;
		m_ValidAngle = m_pEntity->GetAngles();


		if (m_bFirstPerson && m_pVehicle)
		{
			// in vehicle camera
			UpdateBoatCamera();
		}
		else
		if (!m_bFirstPerson)
		{
			//third person camera
			Vec3d pos,angles;
			pos = m_pEntity->GetPos();
			angles = m_pEntity->GetAngles();

			//<<FIXME>> if something with the third person camera doesn't work, talk to Petar
			if (m_pVehicle && m_pVehicle->GetEntity() )	// in vehicle - third person - skip vehicle physiscs when trace camera
			{
				IPhysicalEntity *physEntCar = m_pVehicle->GetEntity()->GetPhysics();
				float	camRange = m_pGame->cl_ThirdPersonRange->GetFVal();
				//				float	waterLevel = m_pGame->GetSystem()->GetI3DEngine()->GetWaterLevel(m_pEntity);
				if(m_pVehicle->GetType() == VHT_BOAT || m_pVehicle->GetType() == VHT_PARAGLIDER )//RAGLIDER IsBoat())
				//					camRange = m_pGame->cl_ThirdPersonRangeBoat->GetFVal();
					camRange = m_pVehicle->m_BoatParams.m_fCameraDist;

				float	camDist = m_pGame->cl_ThirdPersonOffs->GetFVal();
				float	camAVert = m_pGame->cl_ThirdPersonOffsAngVert->GetFVal();
				float	camAHor = m_pGame->cl_ThirdPersonOffsAngHor->GetFVal();
				Vec3 offset(0.0f,camDist, 0.0f);
				Matrix33 targetMt;
				targetMt.SetIdentity();
				targetMt.SetRotationXYZ((m_pVehicle->GetEntity()->GetAngles()+Vec3(camAVert,0.0f,camAHor))*gf_DEGTORAD);
				targetMt.Transpose();
				Matrix33 offsetMt;
				offsetMt.SetIdentity();
				offset = offset*(targetMt);
				offset += m_pVehicle->GetEntity()->GetPos();

				float	waterLevel = m_pGame->GetSystem()->GetI3DEngine()->GetWaterLevel(&offset);
				float	terrainLevel = m_pGame->GetSystem()->GetI3DEngine()->GetTerrainZ((int)offset.x, (int)offset.y);

				camera->SetThirdPersonMode(offset,
						angles,CAMERA_3DPERSON1,frameTime,camRange,!m_bFirstPerson,physEnt,
						//						NULL,
						physEntCar,
						m_pGame->GetSystem()->GetI3DEngine());
			}
			else
				camera->SetThirdPersonMode(pos,angles,CAMERA_3DPERSON1,frameTime,m_pGame->cl_ThirdPersonRange->GetFVal(),!m_bFirstPerson,physEnt );

			ICryCharInstance *pChar = m_pEntity->GetCharInterface()->GetCharacter(0);
			if (m_pGame->cl_ViewFace->GetFVal()>0.0f)
			{
				camera->SetPos( m_pEntity->GetPos()+Vec3d(0,m_pGame->cl_ViewFace->GetFVal(),1.7f));//camera->GetCamOffset());
				camera->SetAngles( Vec3d(0, 0, 0) );
				TRACE("%5.5f", m_pEntity->GetPos().z);
				if (pChar)
					pChar->SetAnimationSpeed(0.00001f);
			}
			else
			{
				if (pChar)
					pChar->SetAnimationSpeed(1.0f);
			}
		}
		else
		{
			// first person
			if( m_CameraMode == PCM_CASUAL)
			{
				UpdateCameraTransition( m_vEyePos );
				camera->SetPos(m_vCurCamposVhcl);
				camera->SetAngles(m_vCurAngleVhcl);
			}
			else
			{
				camera->SetPos(m_vEyePos);
				camera->SetAngles(m_vEyeAngles);
			}
		}
	}

	if (camera)
		camera->Update();
}

//////////////////////////////////////////////////////////////////////////
// sets players EYE position (camera for fpv)
void CPlayer::SetEyePos()
{
	if(m_pGame->p_HeadCamera->GetIVal()||m_pGame->p_HeadCamera2->GetIVal()||!IsAlive())
		SetEyePosBone();
	else
		SetEyePosOffset();
}

//////////////////////////////////////////////////////////////////////////
// sets players EYE position (camera for fpv)
void CPlayer::SetEyePosDead()
{
	if (!m_pBoneHead)
		return;
	SetEyePosBone();
	m_vEyePos.z += .3f;
	CryQuat qt=m_pBoneHead->GetParentWQuat();
	Matrix33	mat(qt);
	Vec3 ang=RAD2DEG(Ang3::GetAnglesXYZ( mat ));
	m_vEyeAngles.x = -ang.x;
	m_vEyeAngles.y = ang.z;
	m_vEyeAngles.z = ang.y;
}


//////////////////////////////////////////////////////////////////////////
// sets players EYE position on head bone (camera for fpv)
void CPlayer::SetEyePosBone()
{
	if (!m_pBoneHead)
		return;

	Vec3d bPos = m_pBoneHead->GetBonePosition();
	//Matrix44 mat;
	//mat=Matrix44::CreateRotationZYX(-m_pEntity->GetAngles()*gf_DEGTORAD); //NOTE: angles in radians and negated
    //bPos = mat.TransformPointOLD(bPos); // ��� ��������� ���������� dir ��� ������, �� ������ �� ������� � ����� ��� Z.
	m_vEyePos = bPos + m_pEntity->GetPos();
	//m_vEyeAngles = m_pEntity->GetAngles(); // �� ������ ������. ��-�� ����� �������� �����������!!!
}

//////////////////////////////////////////////////////////////////////////
// sets players EYE position (camera for fpv)
void CPlayer::SetEyePosOffset()
{
	IEntityCamera *camera = m_pEntity->GetCamera();
	if (!camera)
		return;
	m_vEyePos = CalcLeanOffset(m_walkParams.fCurrLean/*m_walkParams.leanCur*/);
}

//////////////////////////////////////////////////////////////////////////
// Updates the first person view (eg. shaking of camera while walking)
void CPlayer::UpdateFirstPersonView()
{
	IEntityCamera *camera = m_pEntity->GetCamera();

	m_walkParams.runPitch = m_pGame->p_bob_pitch->GetFVal();
	m_walkParams.runRoll = m_pGame->p_bob_roll->GetFVal();
	m_walkParams.stepLength = m_pGame->p_bob_length->GetFVal();
	m_walkParams.weaponCycle = m_pGame->p_bob_weapon->GetFVal();
	m_walkParams.flyCoeff = m_pGame->p_bob_fcoeff->GetFVal();

	// Disable drawing of characters in first person mode.
	m_pEntity->SetRndFlags(ERF_DONOTCHECKVIS, true);
	m_pEntity->SetRndFlags(ERF_RECVSHADOWMAPS|ERF_RECVSHADOWMAPS_ACTIVE, true); // �������� ����.
	m_pEntity->SetRndFlags(ERF_CASTSHADOWMAPS|ERF_CASTSHADOWVOLUME, true); // ����������� ����.
	m_pEntity->SetRndFlags(ERF_FIRST_PERSON_CAMERA_OWNER, true);

	if (m_stats.flying)
	{
		m_walkParams.speed -= m_FlyTime*m_walkParams.flyCoeff;
		if(m_walkParams.speed<0.0f)
			m_walkParams.speed = 0.0f;
	}
	else
	{
		float dump = .30f - m_LandTime;
		if(dump>0)
		{
			m_walkParams.speed -= dump*m_walkParams.flyCoeff;
			if(m_walkParams.speed<0.0f)
				m_walkParams.speed = 0.0f;
		}
	}

	m_walkParams.curLength -= m_walkParams.speed*m_pTimer->GetFrameTime();


	// do this on animation event
	if( m_walkParams.curLength < 0 )
	{
		m_walkParams.curLength = m_walkParams.stepLength;
		//		m_pEntity->SendScriptEvent(ScriptEvent_AnimationKey,0);
	}

	float f = m_walkParams.curLength/m_walkParams.stepLength;

	m_walkParams.prevF = f;

	float roll = m_walkParams.runRoll*m_walkParams.speed;
	float pitch = m_walkParams.runPitch*m_walkParams.speed;

	if(camera)
	{
		// calculate the camera movement, relative
		Vec3 deltaTemp = camera->GetAngles() - m_vPrevCamAngles;
		deltaTemp.x = Snap_s180(deltaTemp.x);
		deltaTemp.y = Snap_s180(deltaTemp.y);
		deltaTemp.z = Snap_s180(deltaTemp.z);

		m_vDeltaCamAngles = 0.5f*(deltaTemp) + 0.5f*m_vDeltaCamAngles;
		m_vDeltaCamPos = 0.5f*(camera->GetPos() - m_vPrevCamPos) + 0.5f*m_vDeltaCamPos;

		m_vPrevCamAngles = camera->GetAngles();
		m_vPrevCamPos = camera->GetPos();

		if (m_Dynamics.gravity!=0.0f)		// head bobbing only if there is gravity
		{
			Vec3d cangles = camera->GetAngles();

			cangles.x += pitch*cry_sinf(f*gf_PI*2.0f);
			cangles.y += roll*cry_sinf(f*gf_PI*2.0f);
			camera->SetAngles(cangles);
		}
	}

	if (m_nSelectedWeaponID != -1)
	{
		Vec3d weaponOffset(0,0,0);

		float lazy_intensity = GetGame()->cl_lazy_weapon->GetFVal();

		if (lazy_intensity > 1.0f) lazy_intensity = 1.0f;

		if (lazy_intensity > 0.0f)
		{
			float frameTime = m_pTimer->GetFrameTime();
			if (frameTime >= 0.0f)
			{
				if (frameTime > 0.5f)
					frameTime = 0.5f;

				assert(_finite(frameTime));
				float maxAngleMovement = 100.0f * frameTime;
				if (m_vDeltaCamAngles.len2()>0.0f || m_vDeltaCamPos.len2()>0.0f)
				{
					m_vDeltaCamAngles *= lazy_intensity;
					m_vDeltaCamPos *= lazy_intensity;
					m_vWeaponAngles -= 0.5f*m_vDeltaCamAngles;
					if (m_vDeltaCamPos.z>0.0f) m_vDeltaCamPos.z *= 0.3f;
					m_vWeaponAngles.x += 30.0f * m_vDeltaCamPos.z;

					assert(_finite(m_vDeltaCamAngles.x));
					assert(_finite(m_vDeltaCamAngles.z));
					assert(_finite(m_vWeaponAngles.x));
					assert(_finite(m_vWeaponAngles.z));

					m_vWeaponAngles.x = CLAMP(m_vWeaponAngles.x, -15.0f, 15.0f);
					m_vWeaponAngles.y = CLAMP(m_vWeaponAngles.y, -15.0f, 15.0f);
					m_vWeaponAngles.z = CLAMP(m_vWeaponAngles.z, -15.0f, 15.0f);
					// limit to maximum angle
					float len2 = m_vWeaponAngles.len2();
					maxAngleMovement*=len2/(15.0f*15.0f);

					// calculate ammount of movement
					Vec3 weaponAngleMovement = -m_vWeaponAngles;
					len2 = weaponAngleMovement.len2();
					if (len2 > maxAngleMovement*maxAngleMovement)
						weaponAngleMovement=0.2f*weaponAngleMovement + 0.7f*(maxAngleMovement)/(cry_sqrtf(len2)) * weaponAngleMovement;

					m_vWeaponAngles += weaponAngleMovement;
					m_vWeaponAngles.x = fmod(m_vWeaponAngles.x, 360.0f);
					m_vWeaponAngles.y = fmod(m_vWeaponAngles.y, 360.0f);
					m_vWeaponAngles.z = fmod(m_vWeaponAngles.z, 360.0f);
				}
			}
		}
		else
		{
			m_vWeaponAngles.Set(0,0,0);
		}

		CWeaponClass* pSelectedWeapon = GetSelectedWeapon();

		//if(m_Dynamics.gravity!=0.0f && !m_pVehicle)		// weapon sway only if there is gravity // ��� ����
		if(!m_pVehicle)		// weapon sway only if there is gravity // ��� �����.
														// and not in vehicle
		{
			weaponOffset.x = cry_sinf(f*gf_PI*2.0f) * m_walkParams.weaponCycle*m_walkParams.speed;
			// [filippo]
			weaponOffset.z = cry_sinf(f*gf_PI*4.0f) * m_walkParams.weaponCycle*m_walkParams.speed*0.35f;
			//weaponOffset.z = cry_sinf(f*gf_PI*4.0f) * m_walkParams.weaponCycle*m_walkParams.speed;
		}

		pSelectedWeapon->SetFirstPersonOffset(weaponOffset,m_vWeaponAngles); // ��� �������� ������ ����� � ������ ����� - ������.
		pSelectedWeapon->MoveToFirstPersonPos(m_pEntity);

		if(m_stats.drawfpweapon)
		{
			ICryCharInstance *pChar = GetEntity()->GetCharInterface()->GetCharacter(1);
			if (pChar)
			{
				GetEntity()->DrawCharacter(1, CS_FLAG_DRAW_NEAR);

				/* PLEASE LEAVE THIS CODE IN HERE
				// adjust first person bounding box
				Matrix44 matWeapon = Matrix34::GetRotationXYZ34( Deg2Rad(pSelectedWeapon->GetAngles()), pSelectedWeapon->GetPos());
				matWeapon.Transpose();

				// get object space bbox
				Vec3 mins,maxs;
				pChar->GetBBox(mins,maxs);
				mins *= GetEntity()->GetScale();
				maxs *= GetEntity()->GetScale();

				// extend this entity's bounding box, by transformed bounding box of weapon
				AABB aabb(mins, maxs);
				aabb.Transform(matWeapon);
				*/
			}
		}
		else
		{
			GetEntity()->DrawCharacter(1,0);
			GetEntity()->ResetAnimations(1);
		}
	}

	m_walkParams.shakeLElapsedTime += m_pTimer->GetFrameTime();
	if(m_walkParams.shakeLElapsedTime < m_walkParams.shakeLTime)
	{
		float amplScale = ( 1.0f - ( m_walkParams.shakeLElapsedTime / m_walkParams.shakeLTime ) );

		m_walkParams.shakeLOffset.x = m_walkParams.shakeLAmpl.x*amplScale*cry_sinf(m_walkParams.shakeLElapsedTime*m_walkParams.shakeLFreq.x*6.283185307179586476925286766559f);
		m_walkParams.shakeLOffset.y = m_walkParams.shakeLAmpl.y*amplScale*cry_cosf(m_walkParams.shakeLElapsedTime*m_walkParams.shakeLFreq.y*6.283185307179586476925286766559f);
		m_walkParams.shakeLOffset.z = m_walkParams.shakeLAmpl.z*amplScale*cry_sinf(m_walkParams.shakeLElapsedTime*m_walkParams.shakeLFreq.z*6.283185307179586476925286766559f + 1.13f);

		Vec3d	shakeAAmpl=Vec3d(60, 30, 30);
		shakeAAmpl = shakeAAmpl*m_walkParams.shakeLAmpl.z;

		m_walkParams.shakeAOffset.x = shakeAAmpl.x*amplScale*cry_sinf(m_walkParams.shakeLElapsedTime*m_walkParams.shakeLFreq.x*6.283185307179586476925286766559f);
		m_walkParams.shakeAOffset.y = shakeAAmpl.y*amplScale*cry_cosf(m_walkParams.shakeLElapsedTime*m_walkParams.shakeLFreq.y*6.283185307179586476925286766559f);
		m_walkParams.shakeAOffset.z = shakeAAmpl.z*amplScale*cry_sinf(m_walkParams.shakeLElapsedTime*m_walkParams.shakeLFreq.z*6.283185307179586476925286766559f + 1.13f);
	}
	else
	{
		m_walkParams.shakeAOffset = Vec3d(0,0,0);
		m_walkParams.shakeLOffset = Vec3d(0,0,0);
		m_walkParams.shakeLElapsedTime = m_walkParams.shakeLTime;
	}
}

//////////////////////////////////////////////////////////////////////////
//so not to do GetBoneByName every frame
bool CPlayer::UpdateBonesPtrs( )
{
	ICryCharInstance *pChar = m_pEntity->GetCharInterface()->GetCharacter(0);

	if (pChar && pChar != m_pLastUsedCharacter)
	{
		m_pLastUsedCharacter = pChar;
		m_pBoneHead = pChar->GetBoneByName("Bip01 Head"); // find bone in the list of bones;
		m_pBoneNeck = pChar->GetBoneByName("Bip01 Neck"); // find bone in the list of bones
		m_pBoneSpine = pChar->GetBoneByName("Bip01 Spine"); // find bone in the list of bones
		m_pBoneSpine1 = pChar->GetBoneByName("Bip01 Spine1"); // find bone in the list of bones
		m_pBoneSpine2 = pChar->GetBoneByName("Bip01 Spine2"); // find bone in the list of bones
		return true;
	}
	return false;
}

//////////////////////////////////////////////////////////////////////////
/*! Updates the third person view (eg. drawing the character)
		@param nWeaponIndex weapon-id to retrieve from
		@return WeaponInfo if the function succeeds, NULL otherwise
*/
void CPlayer::UpdateThirdPersonView( )
{

	if(m_nSelectedWeaponID != -1 && (IsMyPlayer()))
	{
		GetEntity()->DrawCharacter(1,0);
		GetEntity()->ResetAnimations(1);
	}


	m_pEntity->SetRndFlags(ERF_RECVSHADOWMAPS|ERF_RECVSHADOWMAPS_ACTIVE, false); // ���� false. ���������!
	m_pEntity->SetRndFlags(ERF_FIRST_PERSON_CAMERA_OWNER, false); // ���� false. ���������!

	if(IsMyPlayer())
		m_pEntity->SetRndFlags(ERF_CASTSHADOWMAPS | ERF_CASTSHADOWVOLUME, true);
}
