Narrative:
As an operator
I want to be able to operate Dial Pad in different modes
So I can easily initiate a call

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                   | target                 | callType |
| OP1-OP2 | sip:mission1@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1 | sip:222222@example.com   |                        | DA/IDA   |

Scenario: Operator opens phonebook
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
Then HMI OP1 verifies that phone book dial pad has the alphaNumeric layout

Scenario: Operator verifies dial pad layouts
When HMI OP1 toggles the keyboard key
Then HMI OP1 verifies that phone book dial pad has the numeric layout
When HMI OP1 toggles the symbol key
Then HMI OP1 verifies that phone book dial pad has the symbol layout
When HMI OP1 toggles the keyboard key
Then HMI OP1 verifies that phone book dial pad has the numeric layout
When HMI OP1 toggles the keyboard key
Then HMI OP1 verifies that phone book dial pad has the alphaNumeric layout
When HMI OP1 toggles the symbol key
Then HMI OP1 verifies that phone book dial pad has the symbol layout

Scenario: Operator closes and opens the phonebook
When HMI OP1 closes phonebook
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
Then HMI OP1 verifies that phone book dial pad has the alphaNumeric layout

Scenario: Operator verifies keys label
When HMI OP1 presses key s
When HMI OP1 presses key i
When HMI OP1 presses key p
Then HMI OP1 checks that input text box displays sip text
When HMI OP1 presses key shift
When HMI OP1 presses key s
When HMI OP1 presses key shift
When HMI OP1 presses key i
When HMI OP1 presses key shift
When HMI OP1 presses key p
Then HMI OP1 checks that input text box displays sipSIP text
When HMI OP1 deletes a character from text box
When HMI OP1 deletes a character from text box
When HMI OP1 deletes a character from text box
Then HMI OP1 checks that input text box displays sip text
When HMI OP1 presses key shift

Scenario: Operator makes a call using the dialpad keyboard
		  @REQUIREMENTS:GID-2535727
		  @REQUIREMENTS:GID-2536683
When HMI OP1 selects call route selector: none
When HMI OP1 toggles the symbol key
Then waiting for 2 seconds
When HMI OP1 writes in phonebook text box: :
When HMI OP1 toggles the keyboard key
When HMI OP1 presses key 2
When HMI OP1 presses key 2
When HMI OP1 presses key 2
When HMI OP1 presses key 2
When HMI OP1 presses key 2
When HMI OP1 presses key 2
When HMI OP1 toggles the symbol key
When HMI OP1 presses key @
When HMI OP1 toggles the symbol key
When HMI OP1 presses key e
When HMI OP1 presses key x
When HMI OP1 presses key a
When HMI OP1 presses key m
When HMI OP1 presses key p
When HMI OP1 presses key l
When HMI OP1 presses key e
When HMI OP1 toggles the symbol key
Then waiting for 5 seconds
When HMI OP1 writes in phonebook text box: .
When HMI OP1 toggles the symbol key
When HMI OP1 presses key c
When HMI OP1 presses key o
When HMI OP1 presses key m
Then HMI OP1 verifies that phone book call button is enabled
When HMI OP1 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
!-- Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label OP2 Physical
!-- TODO Enable test when bug QXVP-14392 is fixed
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
