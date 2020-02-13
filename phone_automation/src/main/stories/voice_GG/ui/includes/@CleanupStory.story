Scenario: Run on failure
GivenStories: voice_GG/ui/includes/@CleanupUIWindows.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story
Then waiting until the cleanup is done
