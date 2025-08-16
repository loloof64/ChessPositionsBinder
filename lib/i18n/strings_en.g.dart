///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsWidgetsEn widgets = TranslationsWidgetsEn._(_root);
	late final TranslationsPagesEn pages = TranslationsPagesEn._(_root);
}

// Path: widgets
class TranslationsWidgetsEn {
	TranslationsWidgetsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsWidgetsBoardEditorEn board_editor = TranslationsWidgetsBoardEditorEn._(_root);
	late final TranslationsWidgetsPositionInformationFormEn position_information_form = TranslationsWidgetsPositionInformationFormEn._(_root);
	late final TranslationsWidgetsCommanderEn commander = TranslationsWidgetsCommanderEn._(_root);
}

// Path: pages
class TranslationsPagesEn {
	TranslationsPagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsPagesOverallEn overall = TranslationsPagesOverallEn._(_root);
	late final TranslationsPagesHomeEn home = TranslationsPagesHomeEn._(_root);
	late final TranslationsPagesPositionDetailsEn position_details = TranslationsPagesPositionDetailsEn._(_root);
	late final TranslationsPagesPositionEditorEn position_editor = TranslationsPagesPositionEditorEn._(_root);
	late final TranslationsPagesPositionShortcutsEn position_shortcuts = TranslationsPagesPositionShortcutsEn._(_root);
	late final TranslationsPagesDropboxEn dropbox = TranslationsPagesDropboxEn._(_root);
}

// Path: widgets.board_editor
class TranslationsWidgetsBoardEditorEn {
	TranslationsWidgetsBoardEditorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get black_turn => 'Black turn:';
}

// Path: widgets.position_information_form
class TranslationsWidgetsPositionInformationFormEn {
	TranslationsWidgetsPositionInformationFormEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get white_player => 'White player';
	String get black_player => 'Black player';
	String get event => 'Event';
	String get date => 'Date';
	String get exercise => 'Exercise';
}

// Path: widgets.commander
class TranslationsWidgetsCommanderEn {
	TranslationsWidgetsCommanderEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get no_item_selected => 'No item selected.';
	String get folder => 'folder';
	String get file => 'file';
	late final TranslationsWidgetsCommanderNewFolderEn new_folder = TranslationsWidgetsCommanderNewFolderEn._(_root);
	late final TranslationsWidgetsCommanderDeleteItemsEn delete_items = TranslationsWidgetsCommanderDeleteItemsEn._(_root);
}

// Path: pages.overall
class TranslationsPagesOverallEn {
	TranslationsPagesOverallEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsPagesOverallButtonsEn buttons = TranslationsPagesOverallButtonsEn._(_root);
}

// Path: pages.home
class TranslationsPagesHomeEn {
	TranslationsPagesHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Home';
	late final TranslationsPagesHomeCreateFolderDialogEn create_folder_dialog = TranslationsPagesHomeCreateFolderDialogEn._(_root);
	late final TranslationsPagesHomeCreateFolderErrorsEn create_folder_errors = TranslationsPagesHomeCreateFolderErrorsEn._(_root);
	late final TranslationsPagesHomeMiscErrorsEn misc_errors = TranslationsPagesHomeMiscErrorsEn._(_root);
	late final TranslationsPagesHomeDeletePositionDialogEn delete_position_dialog = TranslationsPagesHomeDeletePositionDialogEn._(_root);
	late final TranslationsPagesHomeDeleteFolderDialogEn delete_folder_dialog = TranslationsPagesHomeDeleteFolderDialogEn._(_root);
	late final TranslationsPagesHomeRenamePositionDialogEn rename_position_dialog = TranslationsPagesHomeRenamePositionDialogEn._(_root);
	late final TranslationsPagesHomeRenamePositionErrorsEn rename_position_errors = TranslationsPagesHomeRenamePositionErrorsEn._(_root);
	late final TranslationsPagesHomeRenameFolderErrorsEn rename_folder_errors = TranslationsPagesHomeRenameFolderErrorsEn._(_root);
	late final TranslationsPagesHomeRenameFolderDialogEn rename_folder_dialog = TranslationsPagesHomeRenameFolderDialogEn._(_root);
	late final TranslationsPagesHomeMiscEn misc = TranslationsPagesHomeMiscEn._(_root);
}

// Path: pages.position_details
class TranslationsPagesPositionDetailsEn {
	TranslationsPagesPositionDetailsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String title({required Object fileName}) => 'Position (${fileName})';
}

// Path: pages.position_editor
class TranslationsPagesPositionEditorEn {
	TranslationsPagesPositionEditorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String title({required Object fileName}) => 'Position editor (${fileName})';
	String get simple_title => 'Position editor';
	late final TranslationsPagesPositionEditorSavedFileNameDialogEn saved_file_name_dialog = TranslationsPagesPositionEditorSavedFileNameDialogEn._(_root);
	late final TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEn overwrite_file_confirmation_dialog = TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEn._(_root);
}

// Path: pages.position_shortcuts
class TranslationsPagesPositionShortcutsEn {
	TranslationsPagesPositionShortcutsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsPagesPositionShortcutsErrorsEn errors = TranslationsPagesPositionShortcutsErrorsEn._(_root);
	late final TranslationsPagesPositionShortcutsButtonsEn buttons = TranslationsPagesPositionShortcutsButtonsEn._(_root);
}

// Path: pages.dropbox
class TranslationsPagesDropboxEn {
	TranslationsPagesDropboxEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get failed_getting_auth_page => 'Failed to get to the authentification page.';
	String get enter_auth_code => 'Enter the authentification code';
	String get invalid_auth_code => 'Invalid code';
	late final TranslationsPagesDropboxRequestErrorsEn request_errors = TranslationsPagesDropboxRequestErrorsEn._(_root);
	String get dropbox_explorer => 'Dropbox';
	String get local_explorer => 'Local';
	String get disconnected => 'You are logged out.';
	String get failed_reading_local_content => 'Failed to read local content.';
}

// Path: widgets.commander.new_folder
class TranslationsWidgetsCommanderNewFolderEn {
	TranslationsWidgetsCommanderNewFolderEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Create folder';
	String get name_placeholder => 'Folder name';
}

// Path: widgets.commander.delete_items
class TranslationsWidgetsCommanderDeleteItemsEn {
	TranslationsWidgetsCommanderDeleteItemsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Delete items ?';
	String get message => 'Do you want to delete the following items ?';
}

// Path: pages.overall.buttons
class TranslationsPagesOverallButtonsEn {
	TranslationsPagesOverallButtonsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get ok => 'Ok';
	String get cancel => 'Cancel';
	String get save => 'Save';
	String get validate => 'Validate';
	String get paste => 'Paste';
}

// Path: pages.home.create_folder_dialog
class TranslationsPagesHomeCreateFolderDialogEn {
	TranslationsPagesHomeCreateFolderDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Create folder';
	String get folder_name_placeholder => 'Folder name';
}

// Path: pages.home.create_folder_errors
class TranslationsPagesHomeCreateFolderErrorsEn {
	TranslationsPagesHomeCreateFolderErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get already_exists => 'Folder already exists';
	String get creation_error => 'Failed to create folder';
}

// Path: pages.home.misc_errors
class TranslationsPagesHomeMiscErrorsEn {
	TranslationsPagesHomeMiscErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get failed_editing_position => 'Failed to edit position';
	String get failed_viewing_position_details => 'Failed to view position details';
	String get failed_deleting_position => 'Failed to delete position';
	String get failed_deleting_folder => 'Failed to delete folder';
	String get failed_opening_folder => 'Failed to open folder';
	String get failed_opening_position => 'Failed to open position';
	String failed_reading_position_value({required Object fileName}) => 'Failed to read position from ${fileName}';
}

// Path: pages.home.delete_position_dialog
class TranslationsPagesHomeDeletePositionDialogEn {
	TranslationsPagesHomeDeletePositionDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Delete position ?';
	String message({required Object name}) => 'Are you sure you want to delete position ${name} ?';
}

// Path: pages.home.delete_folder_dialog
class TranslationsPagesHomeDeleteFolderDialogEn {
	TranslationsPagesHomeDeleteFolderDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Delete folder ?';
	String message({required Object name}) => 'Are you sure you want to delete folder ${name} ?';
}

// Path: pages.home.rename_position_dialog
class TranslationsPagesHomeRenamePositionDialogEn {
	TranslationsPagesHomeRenamePositionDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String title({required Object currentName}) => 'Rename position (${currentName})';
	String get name_placeholder => 'New name';
}

// Path: pages.home.rename_position_errors
class TranslationsPagesHomeRenamePositionErrorsEn {
	TranslationsPagesHomeRenamePositionErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get already_exists => 'File already exists';
	String get modification_error => 'Failed to rename position';
}

// Path: pages.home.rename_folder_errors
class TranslationsPagesHomeRenameFolderErrorsEn {
	TranslationsPagesHomeRenameFolderErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get already_exists => 'Folder already exists';
	String get modification_error => 'Failed to rename folder';
}

// Path: pages.home.rename_folder_dialog
class TranslationsPagesHomeRenameFolderDialogEn {
	TranslationsPagesHomeRenameFolderDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String title({required Object newFolderName}) => 'Rename folder (${newFolderName})';
	String get name_placeholder => 'New name';
}

// Path: pages.home.misc
class TranslationsPagesHomeMiscEn {
	TranslationsPagesHomeMiscEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get base_directory => '[BASE_DIR]';
	String get no_item => 'No item';
}

// Path: pages.position_editor.saved_file_name_dialog
class TranslationsPagesPositionEditorSavedFileNameDialogEn {
	TranslationsPagesPositionEditorSavedFileNameDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Select saved file name';
	String get name_placeholder => 'File name';
}

// Path: pages.position_editor.overwrite_file_confirmation_dialog
class TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEn {
	TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Overwrite file ?';
	String message({required Object fileName}) => 'Overwrite file ${fileName} ?';
}

// Path: pages.position_shortcuts.errors
class TranslationsPagesPositionShortcutsErrorsEn {
	TranslationsPagesPositionShortcutsErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get failed_pasting_fen => 'Failed to paste FEN';
}

// Path: pages.position_shortcuts.buttons
class TranslationsPagesPositionShortcutsButtonsEn {
	TranslationsPagesPositionShortcutsButtonsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get paste_fen => 'Paste FEN';
	String get copy_fen => 'Copy FEN';
	String get clear => 'Clear';
	String get reset => 'Reset';
	String get set_start_position => 'Start position';
}

// Path: pages.dropbox.request_errors
class TranslationsPagesDropboxRequestErrorsEn {
	TranslationsPagesDropboxRequestErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get no_client_available => 'No Dropbox client available.';
	String get bad_request_input => 'Bad request input.';
	String get authentification => 'Authentification error.';
	String get no_permission => 'No permission error.';
	String get endpoint => 'Endpoint error.';
	String get rate_limit => 'Rate limit error.';
	String get expired_credentials => 'Credentials have expired.';
	String get misc => 'Misc server error.';
	String get unknown => 'Unknown error.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'widgets.board_editor.black_turn': return 'Black turn:';
			case 'widgets.position_information_form.white_player': return 'White player';
			case 'widgets.position_information_form.black_player': return 'Black player';
			case 'widgets.position_information_form.event': return 'Event';
			case 'widgets.position_information_form.date': return 'Date';
			case 'widgets.position_information_form.exercise': return 'Exercise';
			case 'widgets.commander.no_item_selected': return 'No item selected.';
			case 'widgets.commander.folder': return 'folder';
			case 'widgets.commander.file': return 'file';
			case 'widgets.commander.new_folder.title': return 'Create folder';
			case 'widgets.commander.new_folder.name_placeholder': return 'Folder name';
			case 'widgets.commander.delete_items.title': return 'Delete items ?';
			case 'widgets.commander.delete_items.message': return 'Do you want to delete the following items ?';
			case 'pages.overall.buttons.ok': return 'Ok';
			case 'pages.overall.buttons.cancel': return 'Cancel';
			case 'pages.overall.buttons.save': return 'Save';
			case 'pages.overall.buttons.validate': return 'Validate';
			case 'pages.overall.buttons.paste': return 'Paste';
			case 'pages.home.title': return 'Home';
			case 'pages.home.create_folder_dialog.title': return 'Create folder';
			case 'pages.home.create_folder_dialog.folder_name_placeholder': return 'Folder name';
			case 'pages.home.create_folder_errors.already_exists': return 'Folder already exists';
			case 'pages.home.create_folder_errors.creation_error': return 'Failed to create folder';
			case 'pages.home.misc_errors.failed_editing_position': return 'Failed to edit position';
			case 'pages.home.misc_errors.failed_viewing_position_details': return 'Failed to view position details';
			case 'pages.home.misc_errors.failed_deleting_position': return 'Failed to delete position';
			case 'pages.home.misc_errors.failed_deleting_folder': return 'Failed to delete folder';
			case 'pages.home.misc_errors.failed_opening_folder': return 'Failed to open folder';
			case 'pages.home.misc_errors.failed_opening_position': return 'Failed to open position';
			case 'pages.home.misc_errors.failed_reading_position_value': return ({required Object fileName}) => 'Failed to read position from ${fileName}';
			case 'pages.home.delete_position_dialog.title': return 'Delete position ?';
			case 'pages.home.delete_position_dialog.message': return ({required Object name}) => 'Are you sure you want to delete position ${name} ?';
			case 'pages.home.delete_folder_dialog.title': return 'Delete folder ?';
			case 'pages.home.delete_folder_dialog.message': return ({required Object name}) => 'Are you sure you want to delete folder ${name} ?';
			case 'pages.home.rename_position_dialog.title': return ({required Object currentName}) => 'Rename position (${currentName})';
			case 'pages.home.rename_position_dialog.name_placeholder': return 'New name';
			case 'pages.home.rename_position_errors.already_exists': return 'File already exists';
			case 'pages.home.rename_position_errors.modification_error': return 'Failed to rename position';
			case 'pages.home.rename_folder_errors.already_exists': return 'Folder already exists';
			case 'pages.home.rename_folder_errors.modification_error': return 'Failed to rename folder';
			case 'pages.home.rename_folder_dialog.title': return ({required Object newFolderName}) => 'Rename folder (${newFolderName})';
			case 'pages.home.rename_folder_dialog.name_placeholder': return 'New name';
			case 'pages.home.misc.base_directory': return '[BASE_DIR]';
			case 'pages.home.misc.no_item': return 'No item';
			case 'pages.position_details.title': return ({required Object fileName}) => 'Position (${fileName})';
			case 'pages.position_editor.title': return ({required Object fileName}) => 'Position editor (${fileName})';
			case 'pages.position_editor.simple_title': return 'Position editor';
			case 'pages.position_editor.saved_file_name_dialog.title': return 'Select saved file name';
			case 'pages.position_editor.saved_file_name_dialog.name_placeholder': return 'File name';
			case 'pages.position_editor.overwrite_file_confirmation_dialog.title': return 'Overwrite file ?';
			case 'pages.position_editor.overwrite_file_confirmation_dialog.message': return ({required Object fileName}) => 'Overwrite file ${fileName} ?';
			case 'pages.position_shortcuts.errors.failed_pasting_fen': return 'Failed to paste FEN';
			case 'pages.position_shortcuts.buttons.paste_fen': return 'Paste FEN';
			case 'pages.position_shortcuts.buttons.copy_fen': return 'Copy FEN';
			case 'pages.position_shortcuts.buttons.clear': return 'Clear';
			case 'pages.position_shortcuts.buttons.reset': return 'Reset';
			case 'pages.position_shortcuts.buttons.set_start_position': return 'Start position';
			case 'pages.dropbox.failed_getting_auth_page': return 'Failed to get to the authentification page.';
			case 'pages.dropbox.enter_auth_code': return 'Enter the authentification code';
			case 'pages.dropbox.invalid_auth_code': return 'Invalid code';
			case 'pages.dropbox.request_errors.no_client_available': return 'No Dropbox client available.';
			case 'pages.dropbox.request_errors.bad_request_input': return 'Bad request input.';
			case 'pages.dropbox.request_errors.authentification': return 'Authentification error.';
			case 'pages.dropbox.request_errors.no_permission': return 'No permission error.';
			case 'pages.dropbox.request_errors.endpoint': return 'Endpoint error.';
			case 'pages.dropbox.request_errors.rate_limit': return 'Rate limit error.';
			case 'pages.dropbox.request_errors.expired_credentials': return 'Credentials have expired.';
			case 'pages.dropbox.request_errors.misc': return 'Misc server error.';
			case 'pages.dropbox.request_errors.unknown': return 'Unknown error.';
			case 'pages.dropbox.dropbox_explorer': return 'Dropbox';
			case 'pages.dropbox.local_explorer': return 'Local';
			case 'pages.dropbox.disconnected': return 'You are logged out.';
			case 'pages.dropbox.failed_reading_local_content': return 'Failed to read local content.';
			default: return null;
		}
	}
}

