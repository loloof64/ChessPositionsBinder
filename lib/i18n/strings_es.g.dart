///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEs implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsEs _root = this; // ignore: unused_field

	@override 
	TranslationsEs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEs(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsWidgetsEs widgets = _TranslationsWidgetsEs._(_root);
	@override late final _TranslationsPagesEs pages = _TranslationsPagesEs._(_root);
}

// Path: widgets
class _TranslationsWidgetsEs implements TranslationsWidgetsEn {
	_TranslationsWidgetsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsWidgetsBoardEditorEs board_editor = _TranslationsWidgetsBoardEditorEs._(_root);
	@override late final _TranslationsWidgetsPositionInformationFormEs position_information_form = _TranslationsWidgetsPositionInformationFormEs._(_root);
}

// Path: pages
class _TranslationsPagesEs implements TranslationsPagesEn {
	_TranslationsPagesEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPagesOverallEs overall = _TranslationsPagesOverallEs._(_root);
	@override late final _TranslationsPagesHomeEs home = _TranslationsPagesHomeEs._(_root);
	@override late final _TranslationsPagesPositionDetailsEs position_details = _TranslationsPagesPositionDetailsEs._(_root);
	@override late final _TranslationsPagesPositionEditorEs position_editor = _TranslationsPagesPositionEditorEs._(_root);
	@override late final _TranslationsPagesPositionShortcutsEs position_shortcuts = _TranslationsPagesPositionShortcutsEs._(_root);
	@override late final _TranslationsPagesDropboxEs dropbox = _TranslationsPagesDropboxEs._(_root);
}

// Path: widgets.board_editor
class _TranslationsWidgetsBoardEditorEs implements TranslationsWidgetsBoardEditorEn {
	_TranslationsWidgetsBoardEditorEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get black_turn => 'Turno de Negras:';
}

// Path: widgets.position_information_form
class _TranslationsWidgetsPositionInformationFormEs implements TranslationsWidgetsPositionInformationFormEn {
	_TranslationsWidgetsPositionInformationFormEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get white_player => 'Jugador de Blancas';
	@override String get black_player => 'Jugador de Negras';
	@override String get event => 'Evento';
	@override String get date => 'Fecha';
	@override String get exercise => 'Ejercicio';
}

// Path: pages.overall
class _TranslationsPagesOverallEs implements TranslationsPagesOverallEn {
	_TranslationsPagesOverallEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPagesOverallButtonsEs buttons = _TranslationsPagesOverallButtonsEs._(_root);
}

// Path: pages.home
class _TranslationsPagesHomeEs implements TranslationsPagesHomeEn {
	_TranslationsPagesHomeEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Inicio';
	@override late final _TranslationsPagesHomeCreateFolderDialogEs create_folder_dialog = _TranslationsPagesHomeCreateFolderDialogEs._(_root);
	@override late final _TranslationsPagesHomeCreateFolderErrorsEs create_folder_errors = _TranslationsPagesHomeCreateFolderErrorsEs._(_root);
	@override late final _TranslationsPagesHomeMiscErrorsEs misc_errors = _TranslationsPagesHomeMiscErrorsEs._(_root);
	@override late final _TranslationsPagesHomeDeletePositionDialogEs delete_position_dialog = _TranslationsPagesHomeDeletePositionDialogEs._(_root);
	@override late final _TranslationsPagesHomeDeleteFolderDialogEs delete_folder_dialog = _TranslationsPagesHomeDeleteFolderDialogEs._(_root);
	@override late final _TranslationsPagesHomeRenamePositionDialogEs rename_position_dialog = _TranslationsPagesHomeRenamePositionDialogEs._(_root);
	@override late final _TranslationsPagesHomeRenamePositionErrorsEs rename_position_errors = _TranslationsPagesHomeRenamePositionErrorsEs._(_root);
	@override late final _TranslationsPagesHomeRenameFolderErrorsEs rename_folder_errors = _TranslationsPagesHomeRenameFolderErrorsEs._(_root);
	@override late final _TranslationsPagesHomeRenameFolderDialogEs rename_folder_dialog = _TranslationsPagesHomeRenameFolderDialogEs._(_root);
	@override late final _TranslationsPagesHomeMiscEs misc = _TranslationsPagesHomeMiscEs._(_root);
}

// Path: pages.position_details
class _TranslationsPagesPositionDetailsEs implements TranslationsPagesPositionDetailsEn {
	_TranslationsPagesPositionDetailsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String title({required Object fileName}) => 'Posición (${fileName})';
}

// Path: pages.position_editor
class _TranslationsPagesPositionEditorEs implements TranslationsPagesPositionEditorEn {
	_TranslationsPagesPositionEditorEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String title({required Object fileName}) => 'Editor de posición (${fileName})';
	@override String get simple_title => 'Editor de posición';
	@override late final _TranslationsPagesPositionEditorSavedFileNameDialogEs saved_file_name_dialog = _TranslationsPagesPositionEditorSavedFileNameDialogEs._(_root);
	@override late final _TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEs overwrite_file_confirmation_dialog = _TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEs._(_root);
}

// Path: pages.position_shortcuts
class _TranslationsPagesPositionShortcutsEs implements TranslationsPagesPositionShortcutsEn {
	_TranslationsPagesPositionShortcutsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPagesPositionShortcutsErrorsEs errors = _TranslationsPagesPositionShortcutsErrorsEs._(_root);
	@override late final _TranslationsPagesPositionShortcutsButtonsEs buttons = _TranslationsPagesPositionShortcutsButtonsEs._(_root);
}

// Path: pages.dropbox
class _TranslationsPagesDropboxEs implements TranslationsPagesDropboxEn {
	_TranslationsPagesDropboxEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get failed_getting_auth_page => 'Error al acceder a la página de autenticación.';
	@override String get enter_auth_code => 'Introduzca el código de autenticación';
	@override String get invalid_auth_code => 'Código inválido';
	@override late final _TranslationsPagesDropboxRequestErrorsEs request_errors = _TranslationsPagesDropboxRequestErrorsEs._(_root);
	@override String get dropbox_explorer => 'Dropbox';
	@override String get local_explorer => 'Local';
	@override String get disconnected => 'Has cerrado sesión.';
	@override String get failed_reading_local_content => 'Error al leer el contenido local.';
}

// Path: pages.overall.buttons
class _TranslationsPagesOverallButtonsEs implements TranslationsPagesOverallButtonsEn {
	_TranslationsPagesOverallButtonsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get ok => 'De Acuerdo';
	@override String get cancel => 'Anular';
	@override String get save => 'Guardar';
	@override String get validate => 'Validar';
	@override String get paste => 'Pegar';
}

// Path: pages.home.create_folder_dialog
class _TranslationsPagesHomeCreateFolderDialogEs implements TranslationsPagesHomeCreateFolderDialogEn {
	_TranslationsPagesHomeCreateFolderDialogEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Crear carpeta';
	@override String get folder_name_placeholder => 'Nombre de la carpeta';
}

// Path: pages.home.create_folder_errors
class _TranslationsPagesHomeCreateFolderErrorsEs implements TranslationsPagesHomeCreateFolderErrorsEn {
	_TranslationsPagesHomeCreateFolderErrorsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get already_exists => 'La carpeta ya existe';
	@override String get creation_error => 'Error al crear la carpeta';
}

// Path: pages.home.misc_errors
class _TranslationsPagesHomeMiscErrorsEs implements TranslationsPagesHomeMiscErrorsEn {
	_TranslationsPagesHomeMiscErrorsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get failed_editing_position => 'Error al editar la posición';
	@override String get failed_viewing_position_details => 'Error al ver los detalles de la posición';
	@override String get failed_deleting_position => 'Error al eliminar la posición';
	@override String get failed_deleting_folder => 'Error al eliminar la carpeta';
	@override String get failed_opening_folder => 'Error al abrir la carpeta';
	@override String get failed_opening_position => 'Error al abrir la posición';
	@override String failed_reading_position_value({required Object fileName}) => 'Error al leer la posición desde ${fileName}';
}

// Path: pages.home.delete_position_dialog
class _TranslationsPagesHomeDeletePositionDialogEs implements TranslationsPagesHomeDeletePositionDialogEn {
	_TranslationsPagesHomeDeletePositionDialogEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '¿Eliminar posición?';
	@override String message({required Object name}) => '¿Está seguro de que desea eliminar la posición ${name}?';
}

// Path: pages.home.delete_folder_dialog
class _TranslationsPagesHomeDeleteFolderDialogEs implements TranslationsPagesHomeDeleteFolderDialogEn {
	_TranslationsPagesHomeDeleteFolderDialogEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '¿Eliminar carpeta?';
	@override String message({required Object name}) => '¿Está seguro de que desea eliminar la carpeta ${name}?';
}

// Path: pages.home.rename_position_dialog
class _TranslationsPagesHomeRenamePositionDialogEs implements TranslationsPagesHomeRenamePositionDialogEn {
	_TranslationsPagesHomeRenamePositionDialogEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String title({required Object currentName}) => 'Renombrar posición (${currentName})';
	@override String get name_placeholder => 'Nuevo nombre';
}

// Path: pages.home.rename_position_errors
class _TranslationsPagesHomeRenamePositionErrorsEs implements TranslationsPagesHomeRenamePositionErrorsEn {
	_TranslationsPagesHomeRenamePositionErrorsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get already_exists => 'La posición ya existe';
	@override String get modification_error => 'Error al renombrar la posición';
}

// Path: pages.home.rename_folder_errors
class _TranslationsPagesHomeRenameFolderErrorsEs implements TranslationsPagesHomeRenameFolderErrorsEn {
	_TranslationsPagesHomeRenameFolderErrorsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get already_exists => 'La carpeta ya existe';
	@override String get modification_error => 'Error al renombrar la carpeta';
}

// Path: pages.home.rename_folder_dialog
class _TranslationsPagesHomeRenameFolderDialogEs implements TranslationsPagesHomeRenameFolderDialogEn {
	_TranslationsPagesHomeRenameFolderDialogEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String title({required Object newFolderName}) => 'Renombrar carpeta (${newFolderName})';
	@override String get name_placeholder => 'Nuevo nombre';
}

// Path: pages.home.misc
class _TranslationsPagesHomeMiscEs implements TranslationsPagesHomeMiscEn {
	_TranslationsPagesHomeMiscEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get base_directory => '[PRIMERA_CARPETA]';
	@override String get no_item => 'Ningún elemento';
}

// Path: pages.position_editor.saved_file_name_dialog
class _TranslationsPagesPositionEditorSavedFileNameDialogEs implements TranslationsPagesPositionEditorSavedFileNameDialogEn {
	_TranslationsPagesPositionEditorSavedFileNameDialogEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Seleccionar nombre de archivo';
	@override String get name_placeholder => 'Nombre de archivo';
}

// Path: pages.position_editor.overwrite_file_confirmation_dialog
class _TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEs implements TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEn {
	_TranslationsPagesPositionEditorOverwriteFileConfirmationDialogEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '¿Sobrescribir archivo?';
	@override String message({required Object fileName}) => '¿Sobrescribir archivo ${fileName}?';
}

// Path: pages.position_shortcuts.errors
class _TranslationsPagesPositionShortcutsErrorsEs implements TranslationsPagesPositionShortcutsErrorsEn {
	_TranslationsPagesPositionShortcutsErrorsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get failed_pasting_fen => 'Error al pegar FEN';
}

// Path: pages.position_shortcuts.buttons
class _TranslationsPagesPositionShortcutsButtonsEs implements TranslationsPagesPositionShortcutsButtonsEn {
	_TranslationsPagesPositionShortcutsButtonsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get paste_fen => 'Pegar FEN';
	@override String get copy_fen => 'Copiar FEN';
	@override String get clear => 'Limpiar';
	@override String get reset => 'Restablecer';
	@override String get set_start_position => 'Establecer posición inicial';
}

// Path: pages.dropbox.request_errors
class _TranslationsPagesDropboxRequestErrorsEs implements TranslationsPagesDropboxRequestErrorsEn {
	_TranslationsPagesDropboxRequestErrorsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get no_client_available => 'No hay cliente de Dropbox disponible.';
	@override String get bad_request_input => 'Entrada de solicitud incorrecta.';
	@override String get authentification => 'Error de autenticación.';
	@override String get no_permission => 'Error de permisos insuficientes.';
	@override String get endpoint => 'Error de endpoint.';
	@override String get rate_limit => 'Error de límite de cuota.';
	@override String get expired_credentials => 'Las credenciales han expirado.';
	@override String get misc => 'Error de servidor diverso.';
	@override String get unknown => 'Error desconocido.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsEs {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'widgets.board_editor.black_turn': return 'Turno de Negras:';
			case 'widgets.position_information_form.white_player': return 'Jugador de Blancas';
			case 'widgets.position_information_form.black_player': return 'Jugador de Negras';
			case 'widgets.position_information_form.event': return 'Evento';
			case 'widgets.position_information_form.date': return 'Fecha';
			case 'widgets.position_information_form.exercise': return 'Ejercicio';
			case 'pages.overall.buttons.ok': return 'De Acuerdo';
			case 'pages.overall.buttons.cancel': return 'Anular';
			case 'pages.overall.buttons.save': return 'Guardar';
			case 'pages.overall.buttons.validate': return 'Validar';
			case 'pages.overall.buttons.paste': return 'Pegar';
			case 'pages.home.title': return 'Inicio';
			case 'pages.home.create_folder_dialog.title': return 'Crear carpeta';
			case 'pages.home.create_folder_dialog.folder_name_placeholder': return 'Nombre de la carpeta';
			case 'pages.home.create_folder_errors.already_exists': return 'La carpeta ya existe';
			case 'pages.home.create_folder_errors.creation_error': return 'Error al crear la carpeta';
			case 'pages.home.misc_errors.failed_editing_position': return 'Error al editar la posición';
			case 'pages.home.misc_errors.failed_viewing_position_details': return 'Error al ver los detalles de la posición';
			case 'pages.home.misc_errors.failed_deleting_position': return 'Error al eliminar la posición';
			case 'pages.home.misc_errors.failed_deleting_folder': return 'Error al eliminar la carpeta';
			case 'pages.home.misc_errors.failed_opening_folder': return 'Error al abrir la carpeta';
			case 'pages.home.misc_errors.failed_opening_position': return 'Error al abrir la posición';
			case 'pages.home.misc_errors.failed_reading_position_value': return ({required Object fileName}) => 'Error al leer la posición desde ${fileName}';
			case 'pages.home.delete_position_dialog.title': return '¿Eliminar posición?';
			case 'pages.home.delete_position_dialog.message': return ({required Object name}) => '¿Está seguro de que desea eliminar la posición ${name}?';
			case 'pages.home.delete_folder_dialog.title': return '¿Eliminar carpeta?';
			case 'pages.home.delete_folder_dialog.message': return ({required Object name}) => '¿Está seguro de que desea eliminar la carpeta ${name}?';
			case 'pages.home.rename_position_dialog.title': return ({required Object currentName}) => 'Renombrar posición (${currentName})';
			case 'pages.home.rename_position_dialog.name_placeholder': return 'Nuevo nombre';
			case 'pages.home.rename_position_errors.already_exists': return 'La posición ya existe';
			case 'pages.home.rename_position_errors.modification_error': return 'Error al renombrar la posición';
			case 'pages.home.rename_folder_errors.already_exists': return 'La carpeta ya existe';
			case 'pages.home.rename_folder_errors.modification_error': return 'Error al renombrar la carpeta';
			case 'pages.home.rename_folder_dialog.title': return ({required Object newFolderName}) => 'Renombrar carpeta (${newFolderName})';
			case 'pages.home.rename_folder_dialog.name_placeholder': return 'Nuevo nombre';
			case 'pages.home.misc.base_directory': return '[PRIMERA_CARPETA]';
			case 'pages.home.misc.no_item': return 'Ningún elemento';
			case 'pages.position_details.title': return ({required Object fileName}) => 'Posición (${fileName})';
			case 'pages.position_editor.title': return ({required Object fileName}) => 'Editor de posición (${fileName})';
			case 'pages.position_editor.simple_title': return 'Editor de posición';
			case 'pages.position_editor.saved_file_name_dialog.title': return 'Seleccionar nombre de archivo';
			case 'pages.position_editor.saved_file_name_dialog.name_placeholder': return 'Nombre de archivo';
			case 'pages.position_editor.overwrite_file_confirmation_dialog.title': return '¿Sobrescribir archivo?';
			case 'pages.position_editor.overwrite_file_confirmation_dialog.message': return ({required Object fileName}) => '¿Sobrescribir archivo ${fileName}?';
			case 'pages.position_shortcuts.errors.failed_pasting_fen': return 'Error al pegar FEN';
			case 'pages.position_shortcuts.buttons.paste_fen': return 'Pegar FEN';
			case 'pages.position_shortcuts.buttons.copy_fen': return 'Copiar FEN';
			case 'pages.position_shortcuts.buttons.clear': return 'Limpiar';
			case 'pages.position_shortcuts.buttons.reset': return 'Restablecer';
			case 'pages.position_shortcuts.buttons.set_start_position': return 'Establecer posición inicial';
			case 'pages.dropbox.failed_getting_auth_page': return 'Error al acceder a la página de autenticación.';
			case 'pages.dropbox.enter_auth_code': return 'Introduzca el código de autenticación';
			case 'pages.dropbox.invalid_auth_code': return 'Código inválido';
			case 'pages.dropbox.request_errors.no_client_available': return 'No hay cliente de Dropbox disponible.';
			case 'pages.dropbox.request_errors.bad_request_input': return 'Entrada de solicitud incorrecta.';
			case 'pages.dropbox.request_errors.authentification': return 'Error de autenticación.';
			case 'pages.dropbox.request_errors.no_permission': return 'Error de permisos insuficientes.';
			case 'pages.dropbox.request_errors.endpoint': return 'Error de endpoint.';
			case 'pages.dropbox.request_errors.rate_limit': return 'Error de límite de cuota.';
			case 'pages.dropbox.request_errors.expired_credentials': return 'Las credenciales han expirado.';
			case 'pages.dropbox.request_errors.misc': return 'Error de servidor diverso.';
			case 'pages.dropbox.request_errors.unknown': return 'Error desconocido.';
			case 'pages.dropbox.dropbox_explorer': return 'Dropbox';
			case 'pages.dropbox.local_explorer': return 'Local';
			case 'pages.dropbox.disconnected': return 'Has cerrado sesión.';
			case 'pages.dropbox.failed_reading_local_content': return 'Error al leer el contenido local.';
			default: return null;
		}
	}
}

