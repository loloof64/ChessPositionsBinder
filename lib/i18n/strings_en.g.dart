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
	late final TranslationsMiscEn misc = TranslationsMiscEn._(_root);
	late final TranslationsWidgetsEn widgets = TranslationsWidgetsEn._(_root);
	late final TranslationsPagesEn pages = TranslationsPagesEn._(_root);
}

// Path: misc
class TranslationsMiscEn {
	TranslationsMiscEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsMiscButtonsEn buttons = TranslationsMiscButtonsEn._(_root);

	/// en: 'folder'
	String get folder => 'folder';

	/// en: 'file'
	String get file => 'file';
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
	late final TranslationsPagesHomeEn home = TranslationsPagesHomeEn._(_root);
	late final TranslationsPagesPositionDetailsEn position_details = TranslationsPagesPositionDetailsEn._(_root);
	late final TranslationsPagesPositionEditorEn position_editor = TranslationsPagesPositionEditorEn._(_root);
	late final TranslationsPagesPositionShortcutsEn position_shortcuts = TranslationsPagesPositionShortcutsEn._(_root);
	late final TranslationsPagesDropboxEn dropbox = TranslationsPagesDropboxEn._(_root);
}

// Path: misc.buttons
class TranslationsMiscButtonsEn {
	TranslationsMiscButtonsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Ok'
	String get ok => 'Ok';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Validate'
	String get validate => 'Validate';

	/// en: 'Paste'
	String get paste => 'Paste';
}

// Path: widgets.board_editor
class TranslationsWidgetsBoardEditorEn {
	TranslationsWidgetsBoardEditorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Black turn:'
	String get black_turn => 'Black turn:';
}

// Path: widgets.position_information_form
class TranslationsWidgetsPositionInformationFormEn {
	TranslationsWidgetsPositionInformationFormEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'White player'
	String get white_player => 'White player';

	/// en: 'Black player'
	String get black_player => 'Black player';

	/// en: 'Event'
	String get event => 'Event';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'Exercise'
	String get exercise => 'Exercise';
}

// Path: widgets.commander
class TranslationsWidgetsCommanderEn {
	TranslationsWidgetsCommanderEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No item selected.'
	String get no_item_selected => 'No item selected.';

	late final TranslationsWidgetsCommanderNewFolderEn new_folder = TranslationsWidgetsCommanderNewFolderEn._(_root);
	late final TranslationsWidgetsCommanderDeleteItemsEn delete_items = TranslationsWidgetsCommanderDeleteItemsEn._(_root);
	late final TranslationsWidgetsCommanderCompressItemsEn compress_items = TranslationsWidgetsCommanderCompressItemsEn._(_root);
	late final TranslationsWidgetsCommanderExtractItemsEn extract_items = TranslationsWidgetsCommanderExtractItemsEn._(_root);
}

// Path: pages.home
class TranslationsPagesHomeEn {
	TranslationsPagesHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
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

	/// en: 'Position ($fileName)'
	String title({required Object fileName}) => 'Position (${fileName})';
}

// Path: pages.position_editor
class TranslationsPagesPositionEditorEn {
	TranslationsPagesPositionEditorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Position editor ($fileName)'
	String title({required Object fileName}) => 'Position editor (${fileName})';

	/// en: 'Position editor'
	String get simple_title => 'Position editor';

	late final TranslationsPagesPositionEditorSavedFileNameDialogEn saved_file_name_dialog = TranslationsPagesPositionEditorSavedFileNameDialogEn._(_root);
	late final TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEn overwrite_file_confirmation_dialog = TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEn._(_root);
	late final TranslationsPagesPositionEditorEditorLabelsEn editor_labels = TranslationsPagesPositionEditorEditorLabelsEn._(_root);
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

	/// en: 'Failed to get to the authentification page.'
	String get failed_getting_auth_page => 'Failed to get to the authentification page.';

	/// en: 'Enter the authentification code'
	String get enter_auth_code => 'Enter the authentification code';

	/// en: 'Invalid code'
	String get invalid_auth_code => 'Invalid code';

	late final TranslationsPagesDropboxRequestErrorsEn request_errors = TranslationsPagesDropboxRequestErrorsEn._(_root);

	/// en: 'Dropbox'
	String get dropbox_explorer => 'Dropbox';

	/// en: 'Local'
	String get local_explorer => 'Local';

	/// en: 'You are logged out.'
	String get disconnected => 'You are logged out.';

	/// en: 'Failed to read local content.'
	String get failed_reading_local_content => 'Failed to read local content.';

	/// en: 'Failed to delete items.'
	String get failed_deleting_items => 'Failed to delete items.';

	/// en: 'Failed to upload some items.'
	String get failed_uploading_items => 'Failed to upload some items.';

	/// en: 'Failed to download some items.'
	String get failed_downloading_items => 'Failed to download some items.';

	/// en: 'Folders have been ignored.'
	String get skipped_folders => 'Folders have been ignored.';

	/// en: 'Done upload.'
	String get upload_done => 'Done upload.';

	/// en: 'Done download.'
	String get download_done => 'Done download.';

	late final TranslationsPagesDropboxConfirmUploadFilesEn confirm_upload_files = TranslationsPagesDropboxConfirmUploadFilesEn._(_root);
	late final TranslationsPagesDropboxConfirmDownloadFilesEn confirm_download_files = TranslationsPagesDropboxConfirmDownloadFilesEn._(_root);

	/// en: 'Some items have not been uploaded because they are above 150MB.'
	String get items_too_big => 'Some items have not been uploaded because they are above 150MB.';

	/// en: 'Compressed items.'
	String get success_compressing_items => 'Compressed items.';

	/// en: 'Failed to compress items.'
	String get failed_compressing_items => 'Failed to compress items.';

	/// en: 'Extracted items.'
	String get success_extracting_items => 'Extracted items.';

	/// en: 'Failed to extract items.'
	String get failed_extracting_items => 'Failed to extract items.';

	/// en: 'Some items were ignored as target already exists:'
	String get skipped_extracting_items => 'Some items were ignored as target already exists:';
}

// Path: widgets.commander.new_folder
class TranslationsWidgetsCommanderNewFolderEn {
	TranslationsWidgetsCommanderNewFolderEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create folder'
	String get title => 'Create folder';

	/// en: 'Folder name'
	String get name_placeholder => 'Folder name';
}

// Path: widgets.commander.delete_items
class TranslationsWidgetsCommanderDeleteItemsEn {
	TranslationsWidgetsCommanderDeleteItemsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete items ?'
	String get title => 'Delete items ?';

	/// en: 'Do you want to delete the following items ?'
	String get message => 'Do you want to delete the following items ?';
}

// Path: widgets.commander.compress_items
class TranslationsWidgetsCommanderCompressItemsEn {
	TranslationsWidgetsCommanderCompressItemsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Compress items'
	String get title => 'Compress items';

	/// en: 'Do you want to compress the following items ?'
	String get message => 'Do you want to compress the following items ?';

	/// en: 'Select the name of the archive (without .zip extension):'
	String get prompt => 'Select the name of the archive (without .zip extension):';
}

// Path: widgets.commander.extract_items
class TranslationsWidgetsCommanderExtractItemsEn {
	TranslationsWidgetsCommanderExtractItemsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Extract archives'
	String get title => 'Extract archives';

	/// en: 'Do you want to extract the following archives ? Please notice that it will only extract folders/*.pgn/*.zip elements. Also notice that if some target folders already exists, related extractions will be skipped.'
	String get message => 'Do you want to extract the following archives ? Please notice that it will only extract folders/*.pgn/*.zip elements. Also notice that if some target folders already exists, related extractions will be skipped.';
}

// Path: pages.home.create_folder_dialog
class TranslationsPagesHomeCreateFolderDialogEn {
	TranslationsPagesHomeCreateFolderDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create folder'
	String get title => 'Create folder';

	/// en: 'Folder name'
	String get folder_name_placeholder => 'Folder name';
}

// Path: pages.home.create_folder_errors
class TranslationsPagesHomeCreateFolderErrorsEn {
	TranslationsPagesHomeCreateFolderErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Folder already exists'
	String get already_exists => 'Folder already exists';

	/// en: 'Failed to create folder'
	String get creation_error => 'Failed to create folder';
}

// Path: pages.home.misc_errors
class TranslationsPagesHomeMiscErrorsEn {
	TranslationsPagesHomeMiscErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to edit position'
	String get failed_editing_position => 'Failed to edit position';

	/// en: 'Failed to view position details'
	String get failed_viewing_position_details => 'Failed to view position details';

	/// en: 'Failed to delete position'
	String get failed_deleting_position => 'Failed to delete position';

	/// en: 'Failed to delete folder'
	String get failed_deleting_folder => 'Failed to delete folder';

	/// en: 'Failed to open folder'
	String get failed_opening_folder => 'Failed to open folder';

	/// en: 'Failed to open position'
	String get failed_opening_position => 'Failed to open position';

	/// en: 'Failed to read position from $fileName'
	String failed_reading_position_value({required Object fileName}) => 'Failed to read position from ${fileName}';
}

// Path: pages.home.delete_position_dialog
class TranslationsPagesHomeDeletePositionDialogEn {
	TranslationsPagesHomeDeletePositionDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete position ?'
	String get title => 'Delete position ?';

	/// en: 'Are you sure you want to delete position $name ?'
	String message({required Object name}) => 'Are you sure you want to delete position ${name} ?';
}

// Path: pages.home.delete_folder_dialog
class TranslationsPagesHomeDeleteFolderDialogEn {
	TranslationsPagesHomeDeleteFolderDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete folder ?'
	String get title => 'Delete folder ?';

	/// en: 'Are you sure you want to delete folder $name ?'
	String message({required Object name}) => 'Are you sure you want to delete folder ${name} ?';
}

// Path: pages.home.rename_position_dialog
class TranslationsPagesHomeRenamePositionDialogEn {
	TranslationsPagesHomeRenamePositionDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Rename position ($currentName)'
	String title({required Object currentName}) => 'Rename position (${currentName})';

	/// en: 'New name'
	String get name_placeholder => 'New name';
}

// Path: pages.home.rename_position_errors
class TranslationsPagesHomeRenamePositionErrorsEn {
	TranslationsPagesHomeRenamePositionErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'File already exists'
	String get already_exists => 'File already exists';

	/// en: 'Failed to rename position'
	String get modification_error => 'Failed to rename position';
}

// Path: pages.home.rename_folder_errors
class TranslationsPagesHomeRenameFolderErrorsEn {
	TranslationsPagesHomeRenameFolderErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Folder already exists'
	String get already_exists => 'Folder already exists';

	/// en: 'Failed to rename folder'
	String get modification_error => 'Failed to rename folder';
}

// Path: pages.home.rename_folder_dialog
class TranslationsPagesHomeRenameFolderDialogEn {
	TranslationsPagesHomeRenameFolderDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Rename folder ($newFolderName)'
	String title({required Object newFolderName}) => 'Rename folder (${newFolderName})';

	/// en: 'New name'
	String get name_placeholder => 'New name';
}

// Path: pages.home.misc
class TranslationsPagesHomeMiscEn {
	TranslationsPagesHomeMiscEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '[BASE_DIR]'
	String get base_directory => '[BASE_DIR]';

	/// en: 'No item'
	String get no_item => 'No item';
}

// Path: pages.position_editor.saved_file_name_dialog
class TranslationsPagesPositionEditorSavedFileNameDialogEn {
	TranslationsPagesPositionEditorSavedFileNameDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select saved file name'
	String get title => 'Select saved file name';

	/// en: 'File name'
	String get name_placeholder => 'File name';
}

// Path: pages.position_editor.overwrite_file_confirmation_dialog
class TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEn {
	TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Overwrite file ?'
	String get title => 'Overwrite file ?';

	/// en: 'Overwrite file $fileName ?'
	String message({required Object fileName}) => 'Overwrite file ${fileName} ?';
}

// Path: pages.position_editor.editor_labels
class TranslationsPagesPositionEditorEditorLabelsEn {
	TranslationsPagesPositionEditorEditorLabelsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Player turn'
	String get player_turn => 'Player turn';

	/// en: 'White'
	String get white_player => 'White';

	/// en: 'Black'
	String get black_player => 'Black';

	/// en: 'Roques'
	String get available_castles => 'Roques';

	/// en: 'White O-O'
	String get white_OO => 'White O-O';

	/// en: 'White O-O-O'
	String get white_OOO => 'White O-O-O';

	/// en: 'Black O-O'
	String get black_OO => 'Black O-O';

	/// en: 'Black O-O-O'
	String get black_OOO => 'Black O-O-O';

	/// en: 'En passant'
	String get en_passant => 'En passant';

	/// en: '50 moves rule'
	String get draw_moves_half_count => '50 moves rule';

	/// en: 'Move number'
	String get move_number => 'Move number';

	/// en: 'Submit'
	String get submit_field => 'Submit';

	/// en: 'Current position'
	String get current_position => 'Current position';

	/// en: 'Copy FEN'
	String get copy_fen => 'Copy FEN';

	/// en: 'Paste FEN'
	String get paste_fen => 'Paste FEN';

	/// en: 'Reset position'
	String get reset_position => 'Reset position';

	/// en: 'Standard position'
	String get standard_position => 'Standard position';

	/// en: 'Erase position'
	String get erase_position => 'Erase position';
}

// Path: pages.position_shortcuts.errors
class TranslationsPagesPositionShortcutsErrorsEn {
	TranslationsPagesPositionShortcutsErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to paste FEN'
	String get failed_pasting_fen => 'Failed to paste FEN';
}

// Path: pages.position_shortcuts.buttons
class TranslationsPagesPositionShortcutsButtonsEn {
	TranslationsPagesPositionShortcutsButtonsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Paste FEN'
	String get paste_fen => 'Paste FEN';

	/// en: 'Copy FEN'
	String get copy_fen => 'Copy FEN';

	/// en: 'Clear'
	String get clear => 'Clear';

	/// en: 'Reset'
	String get reset => 'Reset';

	/// en: 'Start position'
	String get set_start_position => 'Start position';
}

// Path: pages.dropbox.request_errors
class TranslationsPagesDropboxRequestErrorsEn {
	TranslationsPagesDropboxRequestErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No Dropbox client available.'
	String get no_client_available => 'No Dropbox client available.';

	/// en: 'Bad request input.'
	String get bad_request_input => 'Bad request input.';

	/// en: 'Authentification error.'
	String get authentification => 'Authentification error.';

	/// en: 'No permission error.'
	String get no_permission => 'No permission error.';

	/// en: 'Endpoint error.'
	String get endpoint => 'Endpoint error.';

	/// en: 'Rate limit error.'
	String get rate_limit => 'Rate limit error.';

	/// en: 'Credentials have expired.'
	String get expired_credentials => 'Credentials have expired.';

	/// en: 'Misc server error.'
	String get misc => 'Misc server error.';

	/// en: 'Unknown error.'
	String get unknown => 'Unknown error.';
}

// Path: pages.dropbox.confirm_upload_files
class TranslationsPagesDropboxConfirmUploadFilesEn {
	TranslationsPagesDropboxConfirmUploadFilesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Upload files ?'
	String get title => 'Upload files ?';

	/// en: 'Do you want to upload the following files ? Folders, and strictly identical files will be ignored.'
	String get message => 'Do you want to upload the following files ? Folders, and strictly identical files will be ignored.';
}

// Path: pages.dropbox.confirm_download_files
class TranslationsPagesDropboxConfirmDownloadFilesEn {
	TranslationsPagesDropboxConfirmDownloadFilesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Download files ?'
	String get title => 'Download files ?';

	/// en: 'Do you want to download the following files ? 'Duplicate files' will be slightly renamed, and folders will be ignored.'
	String get message => 'Do you want to download the following files ? \'Duplicate files\' will be slightly renamed, and folders will be ignored.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'misc.buttons.ok': return 'Ok';
			case 'misc.buttons.cancel': return 'Cancel';
			case 'misc.buttons.save': return 'Save';
			case 'misc.buttons.validate': return 'Validate';
			case 'misc.buttons.paste': return 'Paste';
			case 'misc.folder': return 'folder';
			case 'misc.file': return 'file';
			case 'widgets.board_editor.black_turn': return 'Black turn:';
			case 'widgets.position_information_form.white_player': return 'White player';
			case 'widgets.position_information_form.black_player': return 'Black player';
			case 'widgets.position_information_form.event': return 'Event';
			case 'widgets.position_information_form.date': return 'Date';
			case 'widgets.position_information_form.exercise': return 'Exercise';
			case 'widgets.commander.no_item_selected': return 'No item selected.';
			case 'widgets.commander.new_folder.title': return 'Create folder';
			case 'widgets.commander.new_folder.name_placeholder': return 'Folder name';
			case 'widgets.commander.delete_items.title': return 'Delete items ?';
			case 'widgets.commander.delete_items.message': return 'Do you want to delete the following items ?';
			case 'widgets.commander.compress_items.title': return 'Compress items';
			case 'widgets.commander.compress_items.message': return 'Do you want to compress the following items ?';
			case 'widgets.commander.compress_items.prompt': return 'Select the name of the archive (without .zip extension):';
			case 'widgets.commander.extract_items.title': return 'Extract archives';
			case 'widgets.commander.extract_items.message': return 'Do you want to extract the following archives ? Please notice that it will only extract folders/*.pgn/*.zip elements. Also notice that if some target folders already exists, related extractions will be skipped.';
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
			case 'pages.position_editor.editor_labels.player_turn': return 'Player turn';
			case 'pages.position_editor.editor_labels.white_player': return 'White';
			case 'pages.position_editor.editor_labels.black_player': return 'Black';
			case 'pages.position_editor.editor_labels.available_castles': return 'Roques';
			case 'pages.position_editor.editor_labels.white_OO': return 'White O-O';
			case 'pages.position_editor.editor_labels.white_OOO': return 'White O-O-O';
			case 'pages.position_editor.editor_labels.black_OO': return 'Black O-O';
			case 'pages.position_editor.editor_labels.black_OOO': return 'Black O-O-O';
			case 'pages.position_editor.editor_labels.en_passant': return 'En passant';
			case 'pages.position_editor.editor_labels.draw_moves_half_count': return '50 moves rule';
			case 'pages.position_editor.editor_labels.move_number': return 'Move number';
			case 'pages.position_editor.editor_labels.submit_field': return 'Submit';
			case 'pages.position_editor.editor_labels.current_position': return 'Current position';
			case 'pages.position_editor.editor_labels.copy_fen': return 'Copy FEN';
			case 'pages.position_editor.editor_labels.paste_fen': return 'Paste FEN';
			case 'pages.position_editor.editor_labels.reset_position': return 'Reset position';
			case 'pages.position_editor.editor_labels.standard_position': return 'Standard position';
			case 'pages.position_editor.editor_labels.erase_position': return 'Erase position';
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
			case 'pages.dropbox.failed_deleting_items': return 'Failed to delete items.';
			case 'pages.dropbox.failed_uploading_items': return 'Failed to upload some items.';
			case 'pages.dropbox.failed_downloading_items': return 'Failed to download some items.';
			case 'pages.dropbox.skipped_folders': return 'Folders have been ignored.';
			case 'pages.dropbox.upload_done': return 'Done upload.';
			case 'pages.dropbox.download_done': return 'Done download.';
			case 'pages.dropbox.confirm_upload_files.title': return 'Upload files ?';
			case 'pages.dropbox.confirm_upload_files.message': return 'Do you want to upload the following files ? Folders, and strictly identical files will be ignored.';
			case 'pages.dropbox.confirm_download_files.title': return 'Download files ?';
			case 'pages.dropbox.confirm_download_files.message': return 'Do you want to download the following files ? \'Duplicate files\' will be slightly renamed, and folders will be ignored.';
			case 'pages.dropbox.items_too_big': return 'Some items have not been uploaded because they are above 150MB.';
			case 'pages.dropbox.success_compressing_items': return 'Compressed items.';
			case 'pages.dropbox.failed_compressing_items': return 'Failed to compress items.';
			case 'pages.dropbox.success_extracting_items': return 'Extracted items.';
			case 'pages.dropbox.failed_extracting_items': return 'Failed to extract items.';
			case 'pages.dropbox.skipped_extracting_items': return 'Some items were ignored as target already exists:';
			default: return null;
		}
	}
}

