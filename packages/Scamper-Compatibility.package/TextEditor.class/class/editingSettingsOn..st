settings
editingSettingsOn: aBuilder 
	<systemsettings> 
	(aBuilder group: #codeEditing) 
		label: 'Text Editing';
		noOrdering;
		description: 'All settings concerned with text editing' ;
		with: [	
			(aBuilder setting: #selectionColor)
				target: UITheme;
				default: (Color r: 0.6862170087976539 g: 0.8347996089931574 b: 0.9794721407624634 alpha: 1.0);
				targetSelector: #currentSettings;
				label: 'Selection color'.
			(aBuilder setting: #unfocusedSelectionColor)
				target: UITheme;
				targetSelector: #currentSettings;
				description: 'The color of the selection for unfocused windows' ;
				default: (Color r: 0.729227761485826 g: 0.8318670576735093 b: 0.9335288367546432 alpha: 1.0);
				label: 'Unfocused selection color'.
			(aBuilder setting: #selectionTextColor)
				target: UITheme;
				targetSelector: #currentSettings;
				default: Color black;
				label: 'Selection text color';
				description: 'The color of the selection text'.
			(aBuilder setting: #useSelectionBar)
				target: TextEditor;
				default: true;
				label: 'Show the colored bar on the current line';
				with: [
					(aBuilder setting: #selectionBarColor)
						target: UITheme;
						targetSelector: #currentSettings;
						default: (Color r: 0.6862170087976539 g: 0.8347996089931574 b: 0.9794721407624634 alpha: 0.058823529411764705);
						label: 'Selection bar color'].
			(aBuilder setting: #useSecondarySelection)
				target: TextEditor;
				default: true;
				label: 'Use the secondary selection';
				with: [
					(aBuilder setting: #secondarySelectionTextColor)
						target: UITheme;
						targetSelector: #currentSettings;
						default: Color white;
						label: 'Secondary selection text color'].
			(aBuilder setting: #useFindReplaceSelection)
				target: TextEditor;
				default: true;
				label: 'Use the find and replace selection';
				with: [
					(aBuilder setting: #findReplaceSelectionColor)
						target: UITheme;
						targetSelector: #currentSettings;
						default: (Color r: 1.0 g: 0.6001955034213099 b: 0.0 alpha: 0.4);
						label: 'Find replace selection color'.
					(aBuilder setting: #findReplaceSelectionTextColor)
						target: UITheme;
						targetSelector: #currentSettings;
						default: Color black;
						label: 'Find replace selection text color'].
			(aBuilder setting: #caseSensitiveFinds) 
				label: 'Case sensitive search';
				target: TextEditor;
				default: false;
		 		description: 'If true, then the "find" command in text will always make its searches in a case-sensitive fashion'.
			(aBuilder setting: #blinkingCursor) 
				label: 'Blinking text cursor';
				target: TextEditor;
				default: true;
		 		description: 'When true, the text cursor will blink.'.
			(aBuilder setting: #dumbbellCursor) 
				label: 'Dumbbell-shaped text cursor';
				target: TextEditor;
				default: false;
		 		description: 'When true, the text cursor assumes the shape of a dumbbell, otherwise a vertical bar.'.
			(aBuilder setting: #skipOverMultipleSpaces) 
				label: 'Skip over white space';
				target: TextEditor;
				default: false;
		 		description: 'When true, the text cursor treats multiple white-space characters as a single space for navigating (moving left/right).'.
			(aBuilder setting: #walkAlongDisplayedLine) 
				label: 'Walk along displayed line';
				target: TextEditor;
				default: true;
		 		description: 'If set to true cursor movement will move along displayed lines rather than logical lines'.
		]
