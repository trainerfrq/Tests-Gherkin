GivenStories: voice_GG/ui/Endurance/BookProfiles.story,
			  voice_GG/ui/Endurance/ExternalSIPPhones.story,
			  voice_GG/ui/Endurance/CallQueues.story

Scenario: Operators change the mission on HMI screen
When the following operators are changing mission to missions from the table: <<missionTable|voice_GG/ui/Endurance/Tables/MissionTable>>
Then wait for 5 seconds

Scenario: Op1 calls Op2
When operators initiate calls by pressing DA keys: <<firstSideHandlesCalls|voice_GG/ui/Endurance/Tables/FirstSideHandlesCalls>>
Then call queue items are in the following state: <<firstRoundInitialCallState|voice_GG/ui/Endurance/Tables/FirstRoundInitialCallState>>

Scenario: Op2 answers call
When operators answer calls by pressing DA keys: <<secondSideHandlesCalls|voice_GG/ui/Endurance/Tables/SecondSideHandlesCalls>>
Then call queue items are in the following state: <<firstRoundConnectedCallState|voice_GG/ui/Endurance/Tables/FirstRoundConnectedCallState>>
Then waiting for 10 seconds

Scenario: Op1 terminates call
When operators terminate calls by pressing DA keys: <<firstSideHandlesCalls|voice_GG/ui/Endurance/Tables/FirstSideHandlesCalls>>
Then the number of calls in the call queue is: <<callQueueNumberOfCalls|voice_GG/ui/Endurance/Tables/CallQueueNumberOfCalls>>
Then waiting for 5 seconds

Scenario: Op2 calls Op1
When operators initiate calls by pressing DA keys: <<secondSideHandlesCalls|voice_GG/ui/Endurance/Tables/SecondSideHandlesCalls>>
Then call queue items are in the following state: <<secondRoundInitialCallState|voice_GG/ui/Endurance/Tables/SecondRoundInitialCallState>>

Scenario: Op1 answers call
When operators answer calls by pressing DA keys: <<firstSideHandlesCalls|voice_GG/ui/Endurance/Tables/FirstSideHandlesCalls>>
Then call queue items are in the following state: <<secondRoundConnectedCallState|voice_GG/ui/Endurance/Tables/SecondRoundConnectedCallState>>
Then waiting for 10 seconds

Scenario: Op2 terminates call
When operators terminate calls by pressing DA keys: <<secondSideHandlesCalls|voice_GG/ui/Endurance/Tables/SecondSideHandlesCalls>>
Then the number of calls in the call queue is: <<callQueueNumberOfCalls|voice_GG/ui/Endurance/Tables/CallQueueNumberOfCalls>>
Then waiting for 5 seconds

Scenario: Operators do a call to an external callee
When a call from phone book is done using the following entries: <<phoneBookInitateCalls|voice_GG/ui/Endurance/Tables/PhoneBookInitateCalls>>

Scenario: Externals callee answer calls
When SipContact answers incoming calls
Then call queue items are in the following state: <<phoneBookConnectedCallState|voice_GG/ui/Endurance/Tables/PhoneBookConnectedCallState>>
Then waiting for 10 seconds

Scenario: Operators terminates calls
Then all calls are terminated: <<phoneBookTerminatesCalls|voice_GG/ui/Endurance/Tables/PhoneBookTerminatesCalls>>
Then the number of calls in the call queue is: <<callQueueNumberOfCalls|voice_GG/ui/Endurance/Tables/CallQueueNumberOfCalls>>
Then waiting for 20 seconds

Scenario: Remove SIP Contact
When SipContact is removed
