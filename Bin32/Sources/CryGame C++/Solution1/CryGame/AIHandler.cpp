
//////////////////////////////////////////////////////////////////////
//
//	Crytek Source code
//	Copyright (c) Crytek 2001-2004
//
//  File: AIHAndler.cpp
//  Description: handeling AI signals, changing behaviors
//
//  History:
//  - Dec, 12, 2002: Created by Kirill Bulatsev
//	- February 2005: Modified by Marco Corbetta for SDK release
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "aihandler.h"
#include <ISound.h>
#include <IAISystem.h>
#include <ILipSync.h>

//////////////////////////////////////////////////////////////////////
CAIHandler::CAIHandler(void):
m_pEntity(NULL),
m_pCharacter(NULL),
m_pDefaultCharacter(NULL),
m_pBehavior(NULL),
m_pPreviousBehavior(NULL),
m_pDefaultBehavior(NULL),
m_pDEFAULTDefaultBehavior(NULL),
m_pBehaviorTable(NULL),
m_pBehaviorTableAVAILABLE(NULL),
m_pBehaviorTableINTERNAL(NULL),
m_DamageGrenadeType(-1)
{
	m_pLog=NULL;
}

//////////////////////////////////////////////////////////////////////
CAIHandler::~CAIHandler(void)
{
	if (m_pPreviousBehavior == m_pBehavior)
		m_pPreviousBehavior = 0;

	SAFE_RELEASE(m_pCharacter);
	SAFE_RELEASE(m_pDefaultCharacter);
	SAFE_RELEASE(m_pBehavior);
	SAFE_RELEASE(m_pPreviousBehavior);
	SAFE_RELEASE(m_pDefaultBehavior);
	SAFE_RELEASE(m_pDEFAULTDefaultBehavior);
	SAFE_RELEASE(m_pBehaviorTable);
	SAFE_RELEASE(m_pBehaviorTableAVAILABLE);
	SAFE_RELEASE(m_pBehaviorTableINTERNAL);
}

//////////////////////////////////////////////////////////////////////
void	CAIHandler::Init(CXGame *pGame, IEntity *pEntity, ILog *pLog)
{
	m_pLog=pLog;
	m_pGame = pGame;
	m_pScriptSystem = m_pGame->GetSystem()->GetIScriptSystem();
	m_pScriptObject = pEntity->GetScriptObject();
	m_pEntity = pEntity;

	ILipSync *pLipSync= m_pEntity->GetCharInterface()->GetLipSyncInterface();
	if (pLipSync)
		pLipSync->SetCallbackSink(this);

	_SmartScriptObject	pCharacterTable(m_pScriptSystem, true);

	// character
	// load the character only if it is used
	m_pScriptSystem->GetGlobalValue("AICharacter",pCharacterTable);
	_SmartScriptObject	pAvailableCharacter(m_pScriptSystem, true);
	pCharacterTable->GetValue("AVAILABLE",pAvailableCharacter);
	const char *aiCharacterFileName=NULL;
	const char *aiCharacterName=NULL;
	_SmartScriptObject	pEntityProperties(m_pScriptSystem, true);
	_SmartScriptObject	pEntityPropertiesInstance(m_pScriptSystem, true);
	if(!m_pScriptObject->GetValue("Properties",pEntityProperties))
	{
		pLog->Log("\002 ERROR CAIHandler: can't find Properties. Entity %s", pEntity->GetName());
		goto	BEHAVIOR_LOADING;
	}

	if(!m_pScriptObject->GetValue("PropertiesInstance",pEntityPropertiesInstance))
	{
		pLog->Log("\002 ERROR CAIHandler: can't find PropertiesInstance. Entity %s", pEntity->GetName());
		goto	BEHAVIOR_LOADING;
	}

	if(!pEntityProperties->GetValue("aicharacter_character",aiCharacterName))
	{
		pLog->Log("\002 ERROR CAIHandler: can't find aicharacter_character. Entity %s", pEntity->GetName());
		goto	BEHAVIOR_LOADING;
	}
	if(!pAvailableCharacter->GetValue(aiCharacterName,aiCharacterFileName))
	{
		pLog->Log("\002 ERROR CAIHandler: can't find [%s] in AICharacter.AVAILABLE. Entity %s", aiCharacterName, pEntity->GetName());
		goto	BEHAVIOR_LOADING;
	}

	m_pCharacter = m_pScriptSystem->CreateEmptyObject();
	if(!pCharacterTable->GetValue(aiCharacterName, m_pCharacter))	//[petar] if character script preloaded do not load
	{
		if(m_pScriptSystem->ExecuteFile(aiCharacterFileName,true,true)) // [petar] if not preloaded force load
		{
			if(!pCharacterTable->GetValue(aiCharacterName, m_pCharacter))
			{
			// did not find script for character
				pLog->Log("\002 ERROR CAIHandler: can't find script for character [%s]. Entity %s", aiCharacterFileName, pEntity->GetName());
				Release( &m_pCharacter );
			}
		}
		else
		{
		// could not load script for character
			pLog->Log("\002 ERROR CAIHandler: can't load script for character [%s]. Entity %s", aiCharacterFileName, pEntity->GetName());
			Release( &m_pCharacter );
		}
	}

	// default character initialization
	m_pDefaultCharacter = m_pScriptSystem->CreateEmptyObject();
	if(!pCharacterTable->GetValue("DEFAULT", m_pDefaultCharacter))
	{
		pLog->Log("\002 ERROR CAIHandler: can't find DEFAULT character. Entity %s", pEntity->GetName());
		Release( &m_pDefaultCharacter );
	}

BEHAVIOR_LOADING:
	//////////////////////////////////////////////////////////////////////
	//behaviour
	m_pBehaviorTable = m_pScriptSystem->CreateEmptyObject();
	if(!m_pScriptSystem->GetGlobalValue("AIBehaviour",m_pBehaviorTable))
	{
		Release(&m_pBehaviorTable);
		pLog->Log("\002 ERROR CAIHandler: can't find AIBehaviour table ");
		return;
	}

	m_pBehaviorTableAVAILABLE = m_pScriptSystem->CreateEmptyObject();
	if(!m_pBehaviorTable->GetValue("AVAILABLE",m_pBehaviorTableAVAILABLE))
	{
		pLog->Log("\002 ERROR CAIHandler: can't find AVAILABLE TABLE");
		Release( &m_pBehaviorTableAVAILABLE );
		return;
	}

	m_pBehaviorTableINTERNAL = m_pScriptSystem->CreateEmptyObject();
	if(!m_pBehaviorTable->GetValue("INTERNAL",m_pBehaviorTableINTERNAL))
	{
		pLog->Log("\002 ERROR CAIHandler: can't find AIBehavior.INTERNAL table.");
		Release( &m_pBehaviorTableINTERNAL );
	}

	const char *aiBehaviorFileName=NULL;
	const char *aiBehaviorName=NULL;
	if(!pEntityPropertiesInstance->GetValue("aibehavior_behaviour",aiBehaviorName))
	{
		goto	BEHAVIOR_DEFAULT;
	}
	m_FirstBehaviorName = string(aiBehaviorName);
	if(!m_pBehaviorTableAVAILABLE->GetValue(aiBehaviorName,aiBehaviorFileName))
	{
		if (!m_pBehaviorTableINTERNAL)
		{
			CryError("Internal behaviour table not found. Cannot continue...");
			return;
		}
		if(!m_pBehaviorTableINTERNAL->GetValue(aiBehaviorName,aiBehaviorFileName))
			goto	BEHAVIOR_DEFAULT;
	}

	m_pBehavior = m_pScriptSystem->CreateEmptyObject();
	if(!m_pBehaviorTable->GetValue(aiBehaviorName, m_pBehavior))	//[petar] if behaviour not preloaded
	{
		if(m_pScriptSystem->ExecuteFile(aiBehaviorFileName,true,true)) // [petar] force that it be loaded
		{
			if(!m_pBehaviorTable->GetValue(aiBehaviorName, m_pBehavior))
			{
				// did not find script for character
				// use default behavior
				pLog->Log("\002 ERROR CAIHandler: can't find script for behavior [%s]. Using DEFAULT. Entity %s", aiBehaviorName, pEntity->GetName());
				if(!m_pBehaviorTable->GetValue("DEFAULT", m_pBehavior))
				{
					pLog->Log("\002 ERROR CAIHandler: can't find DEFAULT. Entity %s", aiBehaviorName, pEntity->GetName());
					Release( &m_pBehavior );
				}
			}
		}
		else
		{
			// could not load script for behavior
			pLog->Log("\002 ERROR CAIHandler: can't load script for behavior [%s]. Entity %s", aiBehaviorFileName, pEntity->GetName());
		}
	}

	m_CurrentBehaviorName = aiBehaviorName;

BEHAVIOR_DEFAULT:

	m_pDEFAULTDefaultBehavior = m_pScriptSystem->CreateEmptyObject();
	if(!m_pBehaviorTable->GetValue("DEFAULT", m_pDEFAULTDefaultBehavior))
	{
		pLog->Log("\002 ERROR CAIHandler: can't find DEFAULT. Entity %s", aiBehaviorName, pEntity->GetName());
		Release( &m_pDEFAULTDefaultBehavior );
	}

	if(aiCharacterName)
	{
		m_DefaultBehaviorName = string(aiCharacterName) + string("Idle");

		int	jobFlag=0;
		if( m_pBehavior && m_pBehavior->GetValue("JOB", jobFlag) )
		{
			m_CurrentBehaviorName = m_DefaultBehaviorName;
		}

		m_pDefaultBehavior = m_pScriptSystem->CreateEmptyObject();

		{
			if (!(m_pDefaultBehavior = FindOrLoadTable(m_pBehaviorTable,m_DefaultBehaviorName.c_str())))
			{
					pLog->Log("\004 WARNING can't find default behaviour %s. Entity %s", m_DefaultBehaviorName.c_str(), pEntity->GetName());
					Release( &m_pDefaultBehavior );
			}
		}
	}

	if(m_pBehavior)
		m_pScriptObject->SetValue("Behaviour", m_pBehavior);
	m_pScriptObject->SetValue("DefaultBehaviour", m_DefaultBehaviorName.c_str());


	//
	_SmartScriptObject	pAIAnchorTable(m_pScriptSystem, true);
	if(m_pScriptSystem->GetGlobalValue("AIAnchor",pAIAnchorTable))
		pAIAnchorTable->GetValue("AIOBJECT_DAMAGEGRENADE", m_DamageGrenadeType);

	//////////////////////////////////////////////////////////////////////
	// SoundPacks
	_SmartScriptObject	pSoundPacksTable(m_pScriptSystem, true);

	if(m_pScriptSystem->GetGlobalValue("SOUNDPACK",pSoundPacksTable))	// SOUNDPACK table
	{
		const char *aiSoundPackName=NULL;
		if(pEntityProperties->GetValue("SoundPack",aiSoundPackName))
		{
			m_pSoundPackTable = FindOrLoadTable( pSoundPacksTable, aiSoundPackName );
		}
	}

	//////////////////////////////////////////////////////////////////////
	// AniPacks
	_SmartScriptObject	pAnimPacksTable(m_pScriptSystem, true);

	if(m_pScriptSystem->GetGlobalValue("ANIMATIONPACK",pAnimPacksTable))	// SOUNDPACK table
	{
		const char *aiAnimPackName=NULL;
		if(pEntityProperties->GetValue("AnimPack",aiAnimPackName))
		{
			m_pAnimationPackTable = FindOrLoadTable( pAnimPacksTable, aiAnimPackName );
		}
	}
}

//////////////////////////////////////////////////////////////////////
void	CAIHandler::AIMind( SOBJECTSTATE *state )
{
    //m_pLog->LogToConsole("\004 %s: AIMind",m_pEntity->GetName());
	int	expression=1;
    int AllowVisible=0; // �� � ���� ������ �� ������ ���� 1!
    IEntity *pTargetEntity = 0;
	FUNCTION_PROFILER( m_pGame->GetSystem(),PROFILE_AI );
	HSCRIPTFUNCTION	handlerFunc=NULL;

    IPuppet *pPuppet=0;
    bool IPuppetEntity=m_pEntity->GetAI()->CanBeConvertedTo(AIOBJECT_PUPPET,(void**)&pPuppet);
    float OriginalHorizontalFov;
    m_pEntity->GetScriptObject()->GetValue("OriginalHorizontalFov",OriginalHorizontalFov);
    float CurrentHorizontalFov;
    m_pEntity->GetScriptObject()->GetValue("CurrentHorizontalFov",CurrentHorizontalFov);
    int WasTarget;
    m_pEntity->GetScriptObject()->GetValue("WasTarget",WasTarget);
    int OnPlayerSeenMemory;
    m_pEntity->GetScriptObject()->GetValue("OnPlayerSeenMemory",OnPlayerSeenMemory);
    int sees;
    m_pEntity->GetScriptObject()->GetValue("sees",sees);
	string event_string;
	if( state->bHaveTarget )
	{
        m_pEntity->GetScriptObject()->GetValue("WasTarget",0);
        m_pEntity->GetScriptObject()->GetValue("AllowVisible",AllowVisible); // �������� ��������� �������� ������.
		IAIObject *pObject = m_pEntity->GetAI();
		IPipeUser *pPipeUser = 0;
		if (pObject->CanBeConvertedTo(AIOBJECT_PIPEUSER,(void**)&pPipeUser))
		{
			IAIObject *pTheTarget = pPipeUser->GetAttentionTarget();
			if (pTheTarget)
			{
			    if (pTheTarget->GetType()==AIOBJECT_PLAYER || pTheTarget->GetType()==AIOBJECT_PUPPET)
                    pTargetEntity = (IEntity *) pTheTarget->GetAssociation();
				if (pTargetEntity)
                {
                    bool IsCaged;
                    m_pEntity->GetScriptObject()->GetValue("IsCaged",IsCaged);
                    if (IsCaged) // ���� � � ������, ��..
                        pTargetEntity->GetScriptObject()->SetValue("IsCagedSee", 1);
                    else
                        pTargetEntity->GetScriptObject()->SetValue("IsCagedSee", 0); // ��� � ���� ���������.
                    pTargetEntity->GetScriptObject()->SetValue("ReallySee", 0); // ���� ����� ���-��.
                    /*IPuppet *pPuppet=0;
                    bool IPuppetEntity=m_pEntity->GetAI()->CanBeConvertedTo(AIOBJECT_PUPPET,(void**)&pPuppet);
                    if (IPuppetEntity)
                    {
                        AgentParameters params = pPuppet->GetPuppetParameters();
                        string GetHelm=params.m_fHorizontalFov;
                    }*/
                    //bool MutantInvisible;
                    bool CryVision;
                    m_pEntity->GetScriptObject()->GetValue("CryVision", CryVision);
                    bool TargetIsCaged;
                    pTargetEntity->GetScriptObject()->GetValue("IsCaged",TargetIsCaged);
                    if (TargetIsCaged)
                    {
                        AllowVisible=0;
                        //m_pLog->LogToConsole("\004 %s: TargetIsCaged",m_pEntity->GetName());
                    }
                    else if (CryVision)
                    {
                        //m_pLog->LogToConsole("\004 %s: CryVision",m_pEntity->GetName());
                        AllowVisible=1;
                    }
                    else
                    {
                        //m_pLog->LogToConsole("\004 %s: NOT CRYVISION",m_pEntity->GetName());
                        //m_pEntity->GetScriptObject()->GetValue("AllowVisible",AllowVisible);
                        int IsInvisible; // �������! ��� INT, �� BOOL!!! �����, ����� � ���������� ����������.
                        if (pTargetEntity->GetScriptObject()->GetValue("IsInvisible",IsInvisible)&&state->fDistanceFromTarget>15)
                        {
                            //m_pLog->LogToConsole("\004 %s: HE INVISIBLE",m_pEntity->GetName());
                            if (IPuppetEntity)
                            {
                                AgentParameters params = pPuppet->GetPuppetParameters();
                                CurrentHorizontalFov = 0;
                                params.m_fHorizontalFov = 0;
                                m_pEntity->GetScriptObject()->SetValue("CurrentHorizontalFov", 0);
                                pPuppet->SetPuppetParameters(params);
                            }
                            if (state->fDistanceFromTarget>30)
                                AllowVisible=0;
                            //MutantInvisible = 1;
                        }
                        else
                        {
                            //m_pLog->LogToConsole("\004 %s: HE VISIBLE",m_pEntity->GetName());
                            //m_pLog->LogToConsole("\004 %s: ",m_pEntity->GetName());
                            //m_pEntity->GetScriptObject()->GetValue("AllowVisible",AllowVisible);
                        }
                    }
                    //bool InVehicle = m_pEntity->m_pVehicle->GetType();
                    //bool InVehicle = m_pEntity->GetVehicle()->GetType();
                    bool hely;
                    m_pEntity->GetScriptObject()->GetValue("hely",hely);
                    bool IsCar;
                    m_pEntity->GetScriptObject()->GetValue("IsCar",IsCar);
                    bool IsBoat;
                    m_pEntity->GetScriptObject()->GetValue("IsBoat",IsBoat);
                    //if ((hely||IsCar||IsBoat)&&!MutantInvisible)
                    if (hely||IsCar||IsBoat)
                    {
                        //m_pLog->LogToConsole("\004 %s: hely IsCar IsBoat",m_pEntity->GetName());
                        AllowVisible = 1;
                    }
                }
            }
        }
        //m_pLog->LogToConsole("\004 %s: eng AllowVisible: %d",m_pEntity->GetName(),AllowVisible);
		if( state->nTargetType == m_DamageGrenadeType ) //-- grenade seen
		{
		    //m_pLog->LogToConsole("\004 %s: OnGrenadeSeen",m_pEntity->GetName());
		    m_pEntity->GetScriptObject()->SetValue("not_sees_timer_start", 0);
		    if (IPuppetEntity)
            {
                AgentParameters params = pPuppet->GetPuppetParameters();
                CurrentHorizontalFov = OriginalHorizontalFov;
                params.m_fHorizontalFov = OriginalHorizontalFov;
                m_pEntity->GetScriptObject()->SetValue("CurrentHorizontalFov", OriginalHorizontalFov);
                pPuppet->SetPuppetParameters(params);
            }
		    m_pEntity->GetScriptObject()->SetValue("WasTarget", 1);
			FRAME_PROFILER( "AI_OnGrenadeSeen",m_pGame->GetSystem(),PROFILE_AI );
			CallBehaviorOrDefault( "OnGrenadeSeen", &state->fDistanceFromTarget , false);
			event_string = "OnGrenadeSeen";
			m_pEntity->GetScriptObject()->SetValue("WasInCombat", 1); // � ��� �������-��?
			m_pEntity->GetScriptObject()->SetValue("ReallyGrenadeSees", 1);
		}
		else if( state->bSound )
		{
		    m_pEntity->GetScriptObject()->SetValue("not_sees_timer_start", 0);
            if (sees==0) // ����!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                m_pEntity->GetScriptObject()->SetValue("sees", 2);
		    if (IPuppetEntity)
            {
                AgentParameters params = pPuppet->GetPuppetParameters();
                CurrentHorizontalFov = OriginalHorizontalFov;
                params.m_fHorizontalFov = OriginalHorizontalFov;
                m_pEntity->GetScriptObject()->SetValue("CurrentHorizontalFov", OriginalHorizontalFov);
                pPuppet->SetPuppetParameters(params);
            }
            m_pEntity->GetScriptObject()->SetValue("WasTarget", 1);
			expression = 2;
			if( state->fThreat > state->fInterest ) // �������� ����� � ����������� �� species.
			{
			    //m_pLog->LogToConsole("\004 %s: OnThreateningSoundHeard",m_pEntity->GetName());
				FRAME_PROFILER( "AI_OnThreateningSoundHeard",m_pGame->GetSystem(),PROFILE_AI );
				CallBehaviorOrDefault( "OnThreateningSoundHeard", &state->fDistanceFromTarget );
				event_string = "OnThreateningSoundHeard";
				//if (pTargetEntity)
                //{
                    //float TargetEntityID = pTargetEntity->GetId(); // �� ������� ����������� ID
                    /*float TargetEntityDistanceToTarget = state->fDistanceFromTarget;
                    m_pEntity->GetScriptObject()->SetValue("ThreatenSoundTargetID", TargetEntityID);
                    m_pEntity->GetScriptObject()->SetValue("ThreatenSoundDistanceToTarget", TargetEntityDistanceToTarget);
                    m_pScriptSystem->BeginCall("BasicAI","AddSoundTarget");
                    m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
                    m_pScriptSystem->EndCall();*/

                    /*float PTSTID;
                    float PTSDTT;
                    m_pEntity->GetScriptObject()->GetValue("PrevThreatenSoundTargetID",PTSTID);
                    m_pEntity->GetScriptObject()->GetValue("PrevThreatenSoundDistanceToTarget",PTSDTT);
                    if (PTSTID!=TargetEntityID&&PTSDTT!=state->fDistanceFromTarget)
                    {
                        m_pEntity->GetScriptObject()->SetValue("PrevThreatenSoundTargetID", TargetEntityID);
                        m_pEntity->GetScriptObject()->SetValue("PrevThreatenSoundDistanceToTarget", TargetEntityDistanceToTarget);
                    }*/
                //}
                //_SmartScriptObject pTable(m_pScriptSystem);
                //_SmartScriptObject pEntity(m_pScriptSystem);
                //pTable->SetAt(i, *pEntity);
			}
			else
			{
			    //m_pLog->LogToConsole("\004 %s: OnInterestingSoundHeard",m_pEntity->GetName());
				FRAME_PROFILER( "AI_OnInterestingSoundHeard",m_pGame->GetSystem(),PROFILE_AI );
				CallBehaviorOrDefault( "OnInterestingSoundHeard", &state->fDistanceFromTarget );
				event_string = "OnInterestingSoundHeard";
			}
		}
		else if( state->nTargetType == AIOBJECT_PLAYER && AllowVisible==1) //-- player seen && AllowVisible==1 ����!
		{
		    //m_pLog->LogToConsole("\004 %s: state->nTargetType == AIOBJECT_PLAYER ",m_pEntity->GetName());
			expression = 2;
			if( state->bMemory )
            {
				//m_pLog->LogToConsole("\004 %s: OnPlayerMemory",m_pEntity->GetName());
				CallBehaviorOrDefault( "OnPlayerMemory" );
            }
			else
			{
                if(AllowVisible==1)
                {
                    //m_pLog->LogToConsole("\004 %s: OnPlayerSeen",m_pEntity->GetName());
                    m_pEntity->GetScriptObject()->SetValue("not_sees_timer_start", 0);
                    m_pEntity->GetScriptObject()->SetValue("sees", 1);
                    m_pEntity->GetScriptObject()->SetValue("WasTarget", 1);
                    m_pEntity->GetScriptObject()->SetValue("OnPlayerSeenMemory", 1);
                    if (pTargetEntity)
                        pTargetEntity->GetScriptObject()->SetValue("ReallySee", 1);
                    FRAME_PROFILER( "AI_OnPlayerSeen",m_pGame->GetSystem(),PROFILE_AI );
                    CallBehaviorOrDefault( "OnPlayerSeen", &state->fDistanceFromTarget );
                    expression = 3;
                    event_string = "OnPlayerSeen";
                    m_pEntity->GetScriptObject()->SetValue("WasInCombat", 1);
                }
			}
		}
        /*else if(state->nTargetType == AIOBJECT_DEADBODY) // ��� ������. ���������� �������. � ������ ������� ������� ��� ����������� �������.
        {
            m_pLog->LogToConsole("\004 %s: OnDeadBodySeen",m_pEntity->GetName());
            m_pEntity->GetScriptObject()->SetValue("not_sees_timer_start", 0);
            m_pEntity->GetScriptObject()->SetValue("WasTarget", 1);
            FRAME_PROFILER("OnDeadBodySeen",m_pGame->GetSystem(),PROFILE_AI);
            CallBehaviorOrDefault( "OnDeadBodySeen",&state->fDistanceFromTarget);
            expression = 3;
            event_string = "OnDeadBodySeen";
            m_pEntity->GetScriptObject()->SetValue("WasInCombat", 1);
        }*/
		else
		{
			if( state->fThreat > state->fInterest )
			{
				if( state->bMemory || AllowVisible==0) // || AllowVisible==0 ����.
				{
				    if (OnPlayerSeenMemory==1)
                    {
                        //m_pLog->LogToConsole("\004 %s: OnEnemyMemory",m_pEntity->GetName());
                        m_pEntity->GetScriptObject()->SetValue("not_sees_timer_start", 0);
                        m_pEntity->GetScriptObject()->SetValue("sees", 2);
                        m_pEntity->GetScriptObject()->SetValue("OnPlayerSeenMemory", 0);
                        FRAME_PROFILER( "AI_OnEnemyMemory",m_pGame->GetSystem(),PROFILE_AI );
                        CallBehaviorOrDefault( "OnEnemyMemory", &state->fDistanceFromTarget );
                        expression = 2;
                        event_string = "OnEnemyMemory";
                    }
				}
				else
				{
				    if(AllowVisible==1)
                    {
                        //m_pLog->LogToConsole("\004 %s: OnPlayerSeen2",m_pEntity->GetName());
                        m_pEntity->GetScriptObject()->SetValue("not_sees_timer_start", 0);
                        m_pEntity->GetScriptObject()->SetValue("sees", 1);
                        m_pEntity->GetScriptObject()->SetValue("WasTarget", 1);
                        m_pEntity->GetScriptObject()->SetValue("OnPlayerSeenMemory", 1);
                        if (pTargetEntity)
                            pTargetEntity->GetScriptObject()->SetValue("ReallySee", 1);
                        FRAME_PROFILER( "AI_OnPlayerSeen2",m_pGame->GetSystem(),PROFILE_AI );
                        CallBehaviorOrDefault( "OnPlayerSeen",&state->fDistanceFromTarget);
                        /*int gunout;
                        if (!m_pEntity->GetScriptObject()->GetValue("AI_GunOut",gunout))
                        {
                            IPipeUser *pPuppet;
                            if (m_pEntity->GetAI()->GetType()== AIOBJECT_PUPPET)
                                if (m_pEntity->GetAI()->CanBeConvertedTo(AIOBJECT_PIPEUSER,(void**)&pPuppet))
                                    pPuppet->InsertSubPipe(0,"DRAW_GUN");
                        }*/
                        expression = 3;
                        event_string = "OnPlayerSeen";
                        m_pEntity->GetScriptObject()->SetValue("WasInCombat", 1);
                    }
				}
			}
			else
				if( state->fInterest > 0 )
				{
				    if(AllowVisible==1)
                    {
                        //m_pLog->LogToConsole("\004 %s: OnSomethingSeen",m_pEntity->GetName());
                        m_pEntity->GetScriptObject()->SetValue("not_sees_timer_start", 0);
                        m_pEntity->GetScriptObject()->SetValue("WasTarget", 1);
                        if (pTargetEntity)
                            pTargetEntity->GetScriptObject()->SetValue("ReallySee", 1);
                        FRAME_PROFILER( "AI_OnSomethingSeen",m_pGame->GetSystem(),PROFILE_AI );
                        CallBehaviorOrDefault( "OnSomethingSeen" );
                        expression = 2;
                        event_string = "OnSomethingSeen";
                    }
				}
		}
	}
	else //-- do not have a target
	{
        if (WasTarget!=0)
        {
            m_pLog->LogToConsole("\004 %s: OnNoTarget",m_pEntity->GetName());
		    /*if (IPuppetEntity&&WasTarget>0&&OnPlayerSeenMemory) // ������������ ��� ��� �� ������ �������.
            {
                AgentParameters params = pPuppet->GetPuppetParameters();
                CurrentHorizontalFov = OriginalHorizontalFov;
                params.m_fHorizontalFov = OriginalHorizontalFov;
                m_pEntity->GetScriptObject()->SetValue("CurrentHorizontalFov", OriginalHorizontalFov);
                m_pLog->LogToConsole("\004 %s: SET NOTARGET FOV",m_pEntity->GetName());
                pPuppet->SetPuppetParameters(params);
            }*/
            m_pEntity->GetScriptObject()->SetValue("WasTarget", 0);
            //m_pEntity->GetScriptObject()->SetValue("allow_search", NULL); // �� ���� ��� ����������.
            //m_pEntity->GetScriptObject()->SetValue("allow_idle", NULL);
            //m_pEntity->GetScriptObject()->SetValue("not_sees_timer_start", ���� �������� ���������� �������� �������);
            m_pEntity->GetScriptObject()->SetValue("sees", 0);
            FRAME_PROFILER( "AI_OnNoTarget",m_pGame->GetSystem(),PROFILE_AI );
            CallBehaviorOrDefault( "OnNoTarget" );
            event_string = "OnNoTarget";
        }
	}
	{
	    /*expression:
	    1 - DeadRandomExpressions - dead
		2 - DefaultRandomExpressions - idle
		3 - SearchRandomExpressions - search
		4 - CombatRandomExpressions - combat*/
		FRAME_PROFILER( "AIExpressionScriptEvent",m_pGame->GetSystem(),PROFILE_AI );
		m_pEntity->SendScriptEvent(ScriptEvent_Expression, expression  );
	}

	if(CheckCharacter( event_string.c_str() ))
		DoChangeBehavior( );
}

//////////////////////////////////////////////////////////////////////
void	CAIHandler::AISignal( int signalID, const char * signalText, IEntity *pSender )
{

	FUNCTION_PROFILER( m_pGame->GetSystem(),PROFILE_AI );

	if(signalID == -2)
		signalText = "OnNoHidingPlace";
	else if(signalID == -50)
			signalText = "OnNoFormationPoint";

	if( !signalText )
		return;

	HSCRIPTFUNCTION	singnalHandler=NULL;

	if( !CallScript(m_pBehavior, signalText, NULL, pSender) )
	// try default in behavior
	if( !CallScript(m_pDefaultBehavior, signalText, NULL, pSender) )
	// try global defaul
    CallScript(m_pDEFAULTDefaultBehavior, signalText, NULL, pSender);

	if(CheckCharacter( signalText ))
		DoChangeBehavior( );
}

//////////////////////////////////////////////////////////////////////
bool	CAIHandler::CheckCharacter( const char* signalText )
{
	FUNCTION_PROFILER( m_pGame->GetSystem(),PROFILE_AI );

	if( strlen(signalText)<2 )
		return false;

	_SmartScriptObject	pCharacterTable(m_pScriptSystem, true);
	_SmartScriptObject	pNextBehavior(m_pScriptSystem, true);
	const char *behaviorName=NULL;
	const char *nextBehaviorName=NULL;

	if( m_pBehavior && m_pCharacter )
	{
		behaviorName = m_CurrentBehaviorName.c_str();//m_pBehavior->GetValue("Name", behaviorName);
		if(m_pCharacter->GetValue(behaviorName, pCharacterTable))
		{
			if(pCharacterTable->GetValue(signalText, nextBehaviorName))
			{
				m_NextBehaviorName = nextBehaviorName;

				{
					if (m_pLog->GetVerbosityLevel())
					{
						FRAME_PROFILER( "Logging of the character change",m_pGame->GetSystem(),PROFILE_AI );
						if(m_pEntity && m_pEntity->GetName() && behaviorName && nextBehaviorName && signalText)
							m_pLog->LogToConsole("\004 entity %s changin behavior from %s to %s on signal %s",
							m_pEntity->GetName(), behaviorName, nextBehaviorName, signalText );
					}
				}

				return true;
			}
		}
	}

	if(!m_pDefaultCharacter)
		return false;

	bool tableIsValid = false;
	if(m_pBehavior /*&& m_pBehavior->GetValue("Name", behaviorName)*/)
	{
		behaviorName = m_CurrentBehaviorName.c_str();
		if(!(tableIsValid = m_pDefaultCharacter->GetValue(behaviorName, pCharacterTable)))
			tableIsValid = m_pDefaultCharacter->GetValue("NoBehaviorFound", pCharacterTable);
	}
	else
		tableIsValid = m_pDefaultCharacter->GetValue("NoBehaviorFound", pCharacterTable);

	if( tableIsValid )
		if(pCharacterTable->GetValue(signalText, nextBehaviorName))
		{
			m_NextBehaviorName = nextBehaviorName;
			{
				if (m_pLog->GetVerbosityLevel())
				{
					FRAME_PROFILER( "Logging of DEFAULT character change",m_pGame->GetSystem(),PROFILE_AI );
					if(m_pEntity && m_pEntity->GetName() && behaviorName && nextBehaviorName && signalText)
						m_pLog->Log("\004 entity %s changin behavior from %s to %s on signal %s [DEFAULT character]",
																					m_pEntity->GetName(), behaviorName, nextBehaviorName, signalText );
				}
			}
			return true;
		}
	return false;
}

//////////////////////////////////////////////////////////////////////
void	CAIHandler::DoChangeBehavior( )
{
	FUNCTION_PROFILER( m_pGame->GetSystem(),PROFILE_AI );

	IScriptObject *pNextBehavior=NULL;
	if (m_NextBehaviorName == "PREVIOUS")
	{
		pNextBehavior = m_pPreviousBehavior;
		if (pNextBehavior)
		{
			const char* nextBehaviorName;
			pNextBehavior->GetValue("Name",nextBehaviorName);

			if (m_CurrentBehaviorName == nextBehaviorName)
				return;
			m_CurrentBehaviorName = nextBehaviorName;
		}
	}
	else
	{
		if( m_NextBehaviorName == "FIRST" )
		{
			m_NextBehaviorName = m_FirstBehaviorName;
		}

		const char* nextBehaviorName = m_NextBehaviorName.c_str();
		m_CurrentBehaviorName = m_NextBehaviorName;
		pNextBehavior = m_pScriptSystem->CreateEmptyObject();
		if( !m_pBehaviorTable->GetValue(nextBehaviorName,pNextBehavior) )
		{
			//[petar] if behaviour not preloaded then force loading of it
			FRAME_PROFILER( "On-DemandBehaviourLoading",m_pGame->GetSystem(),PROFILE_AI );
			const char *aiBehaviorFileName;
			if(m_pBehaviorTableAVAILABLE->GetValue(nextBehaviorName,aiBehaviorFileName))
			{
				//fixme - problem with reloading!!!!
				m_pScriptSystem->ExecuteFile(aiBehaviorFileName,true,true);
			}
			else if(m_pBehaviorTableINTERNAL->GetValue(nextBehaviorName,aiBehaviorFileName))
			{
				//fixme - problem with reloading!!!!
				m_pScriptSystem->ExecuteFile(aiBehaviorFileName,true,true);
			}
		}
		if( !m_pBehaviorTable->GetValue(nextBehaviorName,pNextBehavior) )
		{
			Release( &pNextBehavior );
			if(m_pEntity && m_pEntity->GetName() && m_NextBehaviorName.c_str())
			{
				m_pLog->LogToFile("\004 entity %s faild to change behavior to %s.",
																				m_pEntity->GetName(), m_NextBehaviorName.c_str());
			}
		}
	}

	if (pNextBehavior == m_pBehavior)
	{
		if (pNextBehavior!=m_pPreviousBehavior)
			Release(&pNextBehavior);
		return;
	}

	int job=0;
	if (m_pBehavior && m_pBehavior->GetValue( "JOB", job ))
	{
		ICryCharInstance *pCharacter = m_pEntity->GetCharInterface()->GetCharacter(0);
		if (pCharacter)
		{
			pCharacter->StopAnimation(3);
			pCharacter->StopAnimation(4);
		}
		CallBehaviorOrDefault("OnJobExit",NULL,false);

		if (pNextBehavior && !pNextBehavior->GetValue("JOB",job))
		{
			// stop any ongoing conversations
			HSCRIPTFUNCTION	stopConvFunction=NULL;
			if( m_pScriptObject->GetValue("StopConversation", stopConvFunction) )
			{
				m_pScriptSystem->BeginCall(stopConvFunction);
				m_pScriptSystem->PushFuncParam(m_pScriptObject);
				m_pScriptSystem->EndCall();
			}
		}
	}


	if(pNextBehavior)
	{
		if (m_pBehavior)
		{
			int remember_previous;
			if (!m_pBehavior->GetValue("NOPREVIOUS",remember_previous))
			{
				if((m_pPreviousBehavior != pNextBehavior) && (m_pPreviousBehavior!=m_pBehavior))
					Release( &m_pPreviousBehavior );

				m_pPreviousBehavior = m_pBehavior;

			}
		}
		else
		{
			m_pLog->Log("\001 [AIERROR] entity %s had 0 behaviour but behaviour name %s",
							m_pEntity->GetName(),m_CurrentBehaviorName.c_str() );

		}

		m_pBehavior = pNextBehavior;

		m_pScriptObject->SetValue("Behaviour", m_pBehavior);

		int	jobFlag=0;
		if( m_pBehavior->GetValue("JOB", jobFlag) )
		{
			m_CurrentBehaviorName = m_DefaultBehaviorName;
		}

		const char *eventToCallName=NULL;

		if(m_pScriptObject->GetValue("EventToCall", eventToCallName))
		{
		HSCRIPTFUNCTION	functionToCall=NULL;

			CallScript( m_pBehavior, eventToCallName);
			m_pScriptObject->SetValue("EventToCall", "");
		}
	}
}

//////////////////////////////////////////////////////////////////////
void CAIHandler::CallBehaviorOrDefault( const char* signalText, float *value, bool bJob )
{
    HSCRIPTFUNCTION	handlerFunc=NULL;
    int	job;
    if( m_pBehavior )
    {
        if(!CallScript( m_pBehavior, signalText, value ))
        {
            if (bJob)
            {
                if (m_pBehavior->GetValue( "JOB", job ))
                    CallScript( m_pDefaultBehavior, signalText, value );
            }
            else
                CallScript( m_pDefaultBehavior, signalText, value );
        }
    }
}

//////////////////////////////////////////////////////////////////////
bool CAIHandler::CallScript( IScriptObject *scriptTable, const char* funcName, float *value, IEntity *pSender )
{
	FUNCTION_PROFILER( m_pGame->GetSystem(),PROFILE_AI );

	HSCRIPTFUNCTION	functionToCall=NULL;
	if( scriptTable )
	if( scriptTable->GetValue(funcName, functionToCall) )
	{

		// [Carsten] only use strings which are known at compile time...
		// not doing so causes a stack corruption in the frame profiler
		// FRAME_PROFILER( funcName,m_pGame->GetSystem(),PROFILE_AI );
		// sprintf(m_szSignalName,"AISIGNAL: %s",funcName);
		FRAME_PROFILER( "AISIGNAL" , m_pGame->GetSystem(), PROFILE_AI );

		m_pScriptSystem->BeginCall( functionToCall );
		m_pScriptSystem->PushFuncParam(scriptTable);					// self
		m_pScriptSystem->PushFuncParam(m_pScriptObject);
		if(pSender)
			m_pScriptSystem->PushFuncParam(pSender->GetScriptObject());
		else if( value )
			m_pScriptSystem->PushFuncParam( *value );
		m_pScriptSystem->EndCall();
		return true;
	}
	return false;
}

//////////////////////////////////////////////////////////////////////
void	CAIHandler::Release( )
{
}

//////////////////////////////////////////////////////////////////////
void	CAIHandler::Release( IScriptObject **obj )
{
	if((*obj) == NULL)
		return;
	(*obj)->Release();
	(*obj) = NULL;
}

//////////////////////////////////////////////////////////////////////
IScriptObject *CAIHandler::GetMostLikelyTable( IScriptObject *table )
{

	int readcount = table->Count();
	if (!readcount)
		return 0;

	IScriptObject *pSelectedTable = m_pScriptSystem->CreateEmptyObject();
	int probability = rand()%999;
	int	randValue;
	int curValue;
	int	i;
	int sum  = 0;

	for (i=1;i<table->Count()+1;i++)
	{
		table->GetAt(i,pSelectedTable);
		float fProb=0;
		pSelectedTable->GetValue("PROBABILITY",fProb);
		sum+=(int)(fProb);
		if (sum>probability)
			break;
	}

	if (i==table->Count()+1)
	{
		pSelectedTable->Release();
		return 0 ;
	}
	else
		randValue = i;

	table->GetAt(randValue,pSelectedTable);
	if (pSelectedTable->GetValue("USED",curValue))
	{
		int cnt = 0;
		while (pSelectedTable->GetValue("USED",curValue) && cnt<readcount)
		{
			randValue++;
			if (randValue>readcount)
				randValue = 1;
			table->GetAt(randValue,pSelectedTable);
			cnt++;
		}
		if (cnt<readcount)
		{
			pSelectedTable->SetValue("USED",1);
			return pSelectedTable;
		}
		else
		{
			for (int i=1;i<= readcount;i++)
				table->SetToNull("USED");

			pSelectedTable->SetValue("USED",1);
			return pSelectedTable;
		}
	}
	else
	{
		pSelectedTable->SetValue("USED",1);
		return pSelectedTable;
	}
	return 0;
}

//////////////////////////////////////////////////////////////////////
void	CAIHandler::DoReadibilityPack( const char* text )
{
	FUNCTION_PROFILER( m_pGame->GetSystem(),PROFILE_AI );
	if( m_pAnimationPackTable)
	{
        _SmartScriptObject	pAnimationDirective(m_pScriptSystem, true);
		if( m_pAnimationPackTable->GetValue( text, pAnimationDirective )	)
		{
			IScriptObject *pMostLikelyTable = 0;
			if(pMostLikelyTable = GetMostLikelyTable( pAnimationDirective ))
			{
			const char* aniName;
			int		layer;
			float	blendTime;

				pMostLikelyTable->GetValue( "animationName", aniName );
				pMostLikelyTable->GetValue( "layer", layer );
				pMostLikelyTable->GetValue( "blend_time", blendTime );

				IPipeUser *puppet;
				if(m_pEntity->GetAI()->CanBeConvertedTo(AIOBJECT_PIPEUSER, (void**)&puppet))
				{
					IGoalPipe *pipe=m_pGame->GetSystem()->GetAISystem()->CreateGoalPipe( "special_pipe_anipack_wait" );
					GoalParameters	par;
					par.fValue = m_pEntity->GetAnimationLength(aniName);
					pipe->PushGoal( "timeout", 1, par );
					SAIEVENT sev;
					sev.fInterest = par.fValue;
					m_pEntity->GetAI()->Event(AIEVENT_ONBODYSENSOR,&sev);
					puppet->InsertSubPipe(0,"special_pipe_anipack_wait");
				}

				m_pEntity->StartAnimation( 0, aniName, layer, blendTime );
			}
			if (pMostLikelyTable)
				pMostLikelyTable->Release();
		}
	}
	if( m_pSoundPackTable )
	{
		ISoundSystem *pSoundSystem=m_pGame->GetSystem()->GetISoundSystem();

		if (!pSoundSystem) // || !m_pGame->m_p3DEngine)
			return; // no sound can be played anyway
		_SmartScriptObject	pSoundDirective(m_pScriptSystem, true);
		if( m_pSoundPackTable->GetValue( text, pSoundDirective )	)
		{
			IScriptObject *pMostLikelyTable=0;
			if(pMostLikelyTable = GetMostLikelyTable( pSoundDirective ))
			{
                const char*	sndName;
                int volume;
                float min;
                float max;

                const char *snd2DName;
                int snd2Dvolume;
                int temp;
                bool bSkipSound=false;
                _smart_ptr<ISound> pSound;

				pMostLikelyTable->GetValue( "soundFile", sndName );
				pMostLikelyTable->GetValue( "Volume", volume );
				pMostLikelyTable->GetValue( "min", min );
				pMostLikelyTable->GetValue( "max", max );

				if (pMostLikelyTable->GetValue("NOMUTANT",temp)) // �� ����������� �������� �����, ���������� ���� ������ � ����� ����.
				{
					IAIObject *pAIObject = m_pEntity->GetAI();
					if (pAIObject)
					{
						IPipeUser *pPipeUser;
						if (pAIObject->CanBeConvertedTo(AIOBJECT_PIPEUSER,(void**)&pPipeUser))
						{
							IAIObject *pAttTarget = pPipeUser->GetAttentionTarget();
							if (pAttTarget)
							{
								if (pAttTarget->GetType()==AIOBJECT_PUPPET && pAttTarget->GetAssociation())
								{
									IEntity *pTargetEntity = (IEntity*)pAttTarget->GetAssociation();
									if (pTargetEntity)
									{
										bool ismutant;
										if (pTargetEntity->GetScriptObject())
										{
											if (pTargetEntity->GetScriptObject()->GetValue("MUTANT",ismutant))
												bSkipSound = true;
										}
									}
								}
							}
						}
					}
				}
				if (!bSkipSound)
				{
					FRAME_PROFILER( "Lipsych AI Sound",m_pGame->GetSystem(),PROFILE_AI );

					if(m_pEntity && m_pEntity->GetCharInterface())
					{
						ILipSync *pLipSync=m_pEntity->GetCharInterface()->GetLipSyncInterface();
						if (!pLipSync)
						{
							GameWarning("Could not create lip-sync interface ! Is this entity a character ?");
							return;
						}
						bool HelicopterIs; // ������� �������� �� ��������� ���������.
						m_pEntity->GetScriptObject()->GetValue("HelicopterIs",HelicopterIs);
						if (HelicopterIs)
                            volume = 100;

                        /////////////////////////////
                        /*int LoadedDialog = pLipSync->LoadDialog(sndName, volume, min, max, 30.f, 0);

                        //m_pLog->Log("%s: PLAY SOUND 1",m_pEntity->GetName());
                        //ISound *DialogSound = m_pGame->GetSystem()->GetISoundSystem()->GetSound(LoadedDialog);
                        ISound *DialogSound = m_pGame->GetSystem()->GetISoundSystem()->GetSound(LoadedDialog);
                        //m_pLog->Log("%s: PLAY SOUND 2",m_pEntity->GetName());
                        if (DialogSound)
                        {
                            DialogSound->SetPitch(750);
                            m_pLog->Log("%s: PLAY SOUND 3",m_pEntity->GetName());
                        }*/
                        /*//Sound:Load3DSound(val,Flags,CurFireParameters.SoundMinMaxVol[1],CurFireParameters.SoundMinMaxVol[2],CurFireParameters.SoundMinMaxVol[3],128)
                        //SOUND_RELATIVE,SOUND_UNSCALABLE,SOUND_OCCLUSION,SOUND_RADIUS,SOUND_DOPPLER
                        //pSound = pSoundSystem->LoadSound("Mods/Test/alert_to_idle_alone_13_VoiceC.wav",FLAG_SOUND_RELATIVE|FLAG_SOUND_UNSCALABLE|FLAG_SOUND_RADIUS);
                        //pSound = pSoundSystem->LoadSound(sndName,0); // ��� �� ����������� ��� � �� �����...
                        pSound = pSoundSystem->LoadSound("Mods/Test/alert_to_idle_alone_13_VoiceC.wav",0);
                        pSound->SetVolume(255);
                        pSound->SetMinMaxDistance(2,100);
                        pSound->SetPosition(m_pEntity->GetPos());
                        //pSound->SetPitch(750); // ������ ����.
                        pSound->Play(1); // �������������, �� � ������ � ������. 1 ������� - ��������� ���������. 1 - ������������.
                        m_pLog->Log("%s: PLAY SOUND",m_pEntity->GetName());
						volume = 0;
                        //GetName()
						//if (!LoadedDialog)*/

						m_pScriptSystem->BeginCall("BasicPlayer","SayWord");
                        m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
                        m_pScriptSystem->PushFuncParam(sndName);
                        //m_pScriptSystem->PushFuncParam(0);
                        m_pScriptSystem->PushFuncParam(FLAG_SOUND_RADIUS|FLAG_SOUND_OCCLUSION|FLAG_SOUND_UNSCALABLE);
                        m_pScriptSystem->PushFuncParam(volume);
                        m_pScriptSystem->PushFuncParam(min);
                        m_pScriptSystem->PushFuncParam(max);
                        //m_pScriptSystem->PushFuncParam(NULL);
                        //m_pScriptSystem->PushFuncParam(1); //
                        m_pScriptSystem->EndCall();
                        /////////////////////////////

						//if (!pLipSync->LoadDialog(sndName, volume, min, max, 30.f, 0))
						//if (!pLipSync->LoadDialog(sndName, 0, 0, 100, 30.f, FLAG_SOUND_2D)) // ����� ���������. ������ �������� ������ �������.
						if (!pLipSync->LoadDialog(sndName, 0, 0, 100, 30.f, 0)) // ����� ���������. ������ �������� ������ �������.
						{
							GameWarning("CLipSync::LoadDialog failed!");
							//return;
						}
					}

					if (pMostLikelyTable->GetValue( "radiosoundFile", snd2DName )) // ��� ������, ������� ���������� ����� ���������. ��� � �� �������������.
					{
						if (pMostLikelyTable->GetValue( "radioVolume", snd2Dvolume ))
						{
							pSound = pSoundSystem->LoadSound(snd2DName,FLAG_SOUND_2D|FLAG_SOUND_STEREO);
							pSound->SetVolume(snd2Dvolume);
							//pSound->SetPitch(750);
							//m_pLog->Log("%s: PLAY SOUND!!!",m_pEntity->GetName());
							pSound->Play();
						}
					}
                    // ��� ����� ��� �� ������� ����-�����.
                    Vec3d Pos = m_pEntity->GetPos();
                    int ID = m_pEntity->GetId();
                    IAIObject *pObject = m_pEntity->GetAI();
                    float Radius = (min+max)/2;
                    m_pGame->GetSystem()->GetAISystem()->SoundEvent(ID,Pos,Radius,0,1,pObject);
                    //m_pLog->Log("%s: PLAY SOUND!!!",m_pEntity->GetName());
				}
			}
			if (pMostLikelyTable)
				pMostLikelyTable->Release();
		}
	}
}

//////////////////////////////////////////////////////////////////////
IScriptObject *CAIHandler::FindOrLoadTable( IScriptObject * globalTable, const char* nameToGet )
{
	IScriptObject *resTable = m_pScriptSystem->CreateEmptyObject();;

	if(globalTable->GetValue(nameToGet, resTable))
		return resTable;

	_SmartScriptObject	pAvailableTable(m_pScriptSystem, true);
	globalTable->GetValue("AVAILABLE",pAvailableTable);
	const char *fileName=NULL;
	if(!pAvailableTable->GetValue(nameToGet,fileName))
	{
		_SmartScriptObject	pInternalTable(m_pScriptSystem, true);
		globalTable->GetValue("INTERNAL",pInternalTable);
		if(!pInternalTable->GetValue(nameToGet,fileName))
		{
			Release( &resTable );
			return resTable;
		}
	}

	if(m_pScriptSystem->ExecuteFile(fileName,true,false))
	{
		if(!globalTable->GetValue(nameToGet, resTable))
		{
			// did not find script for character
			// pLog->Log("\002 ERROR CAIHandler: can't find script for character [%s]. Entity %s", aiCharacterFileName, pEntity->GetName());
			Release( &resTable );
		}
	}
	else
	{
		// could not load script for character
		// pLog->Log("\002 ERROR CAIHandler: can't load script for character [%s]. Entity %s", aiCharacterFileName, pEntity->GetName());
		Release( &resTable );
	}

	return resTable;
}

//////////////////////////////////////////////////////////////////////
void CAIHandler::SetCurrentBehaviourVariable(const char * szVariableName, float fValue)
{
	if (m_pBehavior)
		m_pBehavior->SetValue(szVariableName,fValue);
}

//////////////////////////////////////////////////////////////////////
void CAIHandler::OnDialogLoaded(struct ILipSync *pLipSync)
{
	if (!pLipSync->PlayDialog())
	{
		GameWarning("CLipSync::PlayDialog failed !");
		return ;
	}
}

//////////////////////////////////////////////////////////////////////
void CAIHandler::OnDialogFailed(struct ILipSync *pLipSync)
{
}
