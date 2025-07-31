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
class TranslationsFr implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsFr _root = this; // ignore: unused_field

	@override 
	TranslationsFr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFr(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsWidgetsFr widgets = _TranslationsWidgetsFr._(_root);
	@override late final _TranslationsPagesFr pages = _TranslationsPagesFr._(_root);
}

// Path: widgets
class _TranslationsWidgetsFr implements TranslationsWidgetsEn {
	_TranslationsWidgetsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsWidgetsBoardEditorFr board_editor = _TranslationsWidgetsBoardEditorFr._(_root);
	@override late final _TranslationsWidgetsPositionInformationFormFr position_information_form = _TranslationsWidgetsPositionInformationFormFr._(_root);
}

// Path: pages
class _TranslationsPagesFr implements TranslationsPagesEn {
	_TranslationsPagesFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPagesOverallFr overall = _TranslationsPagesOverallFr._(_root);
	@override late final _TranslationsPagesHomeFr home = _TranslationsPagesHomeFr._(_root);
	@override late final _TranslationsPagesPositionDetailsFr position_details = _TranslationsPagesPositionDetailsFr._(_root);
	@override late final _TranslationsPagesPositionEditorFr position_editor = _TranslationsPagesPositionEditorFr._(_root);
	@override late final _TranslationsPagesPositionShortcutsFr position_shortcuts = _TranslationsPagesPositionShortcutsFr._(_root);
}

// Path: widgets.board_editor
class _TranslationsWidgetsBoardEditorFr implements TranslationsWidgetsBoardEditorEn {
	_TranslationsWidgetsBoardEditorFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get black_turn => 'Trait aux Noirs:';
}

// Path: widgets.position_information_form
class _TranslationsWidgetsPositionInformationFormFr implements TranslationsWidgetsPositionInformationFormEn {
	_TranslationsWidgetsPositionInformationFormFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get white_player => 'Joueur Blanc';
	@override String get black_player => 'Joueur Noir';
	@override String get event => 'Évènement';
	@override String get date => 'Date';
	@override String get exercise => 'Exercice';
}

// Path: pages.overall
class _TranslationsPagesOverallFr implements TranslationsPagesOverallEn {
	_TranslationsPagesOverallFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPagesOverallButtonsFr buttons = _TranslationsPagesOverallButtonsFr._(_root);
}

// Path: pages.home
class _TranslationsPagesHomeFr implements TranslationsPagesHomeEn {
	_TranslationsPagesHomeFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Page principale';
	@override late final _TranslationsPagesHomeCreateFolderDialogFr create_folder_dialog = _TranslationsPagesHomeCreateFolderDialogFr._(_root);
	@override late final _TranslationsPagesHomeCreateFolderErrorsFr create_folder_errors = _TranslationsPagesHomeCreateFolderErrorsFr._(_root);
	@override late final _TranslationsPagesHomeMiscErrorsFr misc_errors = _TranslationsPagesHomeMiscErrorsFr._(_root);
	@override late final _TranslationsPagesHomeDeletePositionDialogFr delete_position_dialog = _TranslationsPagesHomeDeletePositionDialogFr._(_root);
	@override late final _TranslationsPagesHomeDeleteFolderDialogFr delete_folder_dialog = _TranslationsPagesHomeDeleteFolderDialogFr._(_root);
	@override late final _TranslationsPagesHomeRenamePositionDialogFr rename_position_dialog = _TranslationsPagesHomeRenamePositionDialogFr._(_root);
	@override late final _TranslationsPagesHomeRenamePositionErrorsFr rename_position_errors = _TranslationsPagesHomeRenamePositionErrorsFr._(_root);
	@override late final _TranslationsPagesHomeRenameFolderErrorsFr rename_folder_errors = _TranslationsPagesHomeRenameFolderErrorsFr._(_root);
	@override late final _TranslationsPagesHomeRenameFolderDialogFr rename_folder_dialog = _TranslationsPagesHomeRenameFolderDialogFr._(_root);
	@override late final _TranslationsPagesHomeMiscFr misc = _TranslationsPagesHomeMiscFr._(_root);
}

// Path: pages.position_details
class _TranslationsPagesPositionDetailsFr implements TranslationsPagesPositionDetailsEn {
	_TranslationsPagesPositionDetailsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String title({required Object fileName}) => 'Détails de la position (${fileName})';
}

// Path: pages.position_editor
class _TranslationsPagesPositionEditorFr implements TranslationsPagesPositionEditorEn {
	_TranslationsPagesPositionEditorFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String title({required Object fileName}) => 'Éditeur de position (${fileName})';
	@override String get simple_title => 'Éditeur de position';
	@override late final _TranslationsPagesPositionEditorSavedFileNameDialogFr saved_file_name_dialog = _TranslationsPagesPositionEditorSavedFileNameDialogFr._(_root);
}

// Path: pages.position_shortcuts
class _TranslationsPagesPositionShortcutsFr implements TranslationsPagesPositionShortcutsEn {
	_TranslationsPagesPositionShortcutsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPagesPositionShortcutsErrorsFr errors = _TranslationsPagesPositionShortcutsErrorsFr._(_root);
	@override late final _TranslationsPagesPositionShortcutsButtonsFr buttons = _TranslationsPagesPositionShortcutsButtonsFr._(_root);
}

// Path: pages.overall.buttons
class _TranslationsPagesOverallButtonsFr implements TranslationsPagesOverallButtonsEn {
	_TranslationsPagesOverallButtonsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get ok => 'Ok';
	@override String get cancel => 'Annuler';
	@override String get save => 'Sauvegarder';
}

// Path: pages.home.create_folder_dialog
class _TranslationsPagesHomeCreateFolderDialogFr implements TranslationsPagesHomeCreateFolderDialogEn {
	_TranslationsPagesHomeCreateFolderDialogFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Créer un dossier';
	@override String get folder_name_placeholder => 'Nom du dossier';
}

// Path: pages.home.create_folder_errors
class _TranslationsPagesHomeCreateFolderErrorsFr implements TranslationsPagesHomeCreateFolderErrorsEn {
	_TranslationsPagesHomeCreateFolderErrorsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get already_exists => 'Le dossier existe déjà';
	@override String get creation_error => 'Échec de création du dossier';
}

// Path: pages.home.misc_errors
class _TranslationsPagesHomeMiscErrorsFr implements TranslationsPagesHomeMiscErrorsEn {
	_TranslationsPagesHomeMiscErrorsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get failed_editing_position => 'Échec d\'édition de la position';
	@override String get failed_viewing_position_details => 'Échec de lecture des détails de la position';
	@override String get failed_deleting_position => 'Échec de suppression de la position';
	@override String get failed_deleting_folder => 'Échec de suppression du dossier';
	@override String get failed_opening_folder => 'Échec d\'ouverture du dossier';
	@override String get failed_opening_position => 'Échec d\'ouverture de la position';
	@override String failed_reading_position_value({required Object fileName}) => 'Échec de lecture de la position du fichier ${fileName}';
}

// Path: pages.home.delete_position_dialog
class _TranslationsPagesHomeDeletePositionDialogFr implements TranslationsPagesHomeDeletePositionDialogEn {
	_TranslationsPagesHomeDeletePositionDialogFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Supprimer la position ?';
	@override String message({required Object name}) => 'Êtes vous-sûr de vouloir supprimer la position ${name} ?';
}

// Path: pages.home.delete_folder_dialog
class _TranslationsPagesHomeDeleteFolderDialogFr implements TranslationsPagesHomeDeleteFolderDialogEn {
	_TranslationsPagesHomeDeleteFolderDialogFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Supprimer le dossier';
	@override String message({required Object name}) => 'Êtes vous-sûr de vouloir supprimer le dossier ${name} ?';
}

// Path: pages.home.rename_position_dialog
class _TranslationsPagesHomeRenamePositionDialogFr implements TranslationsPagesHomeRenamePositionDialogEn {
	_TranslationsPagesHomeRenamePositionDialogFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String title({required Object currentName}) => 'Renommer la position (${currentName})';
	@override String get name_placeholder => 'Nouveau nom';
}

// Path: pages.home.rename_position_errors
class _TranslationsPagesHomeRenamePositionErrorsFr implements TranslationsPagesHomeRenamePositionErrorsEn {
	_TranslationsPagesHomeRenamePositionErrorsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get already_exists => 'Le fichier existe déjà';
	@override String get modification_error => 'Échec de modification du nom de fichier';
}

// Path: pages.home.rename_folder_errors
class _TranslationsPagesHomeRenameFolderErrorsFr implements TranslationsPagesHomeRenameFolderErrorsEn {
	_TranslationsPagesHomeRenameFolderErrorsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get already_exists => 'Le dossier existe déjà';
	@override String get modification_error => 'Échec de modification du nom de dossier';
}

// Path: pages.home.rename_folder_dialog
class _TranslationsPagesHomeRenameFolderDialogFr implements TranslationsPagesHomeRenameFolderDialogEn {
	_TranslationsPagesHomeRenameFolderDialogFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String title({required Object newFolderName}) => 'Renommer le dossier (${newFolderName})';
	@override String get name_placeholder => 'Nouveau nom';
}

// Path: pages.home.misc
class _TranslationsPagesHomeMiscFr implements TranslationsPagesHomeMiscEn {
	_TranslationsPagesHomeMiscFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get base_directory => '[DOSSIER_DE_BASE]';
	@override String get no_item => 'Aucun élément';
}

// Path: pages.position_editor.saved_file_name_dialog
class _TranslationsPagesPositionEditorSavedFileNameDialogFr implements TranslationsPagesPositionEditorSavedFileNameDialogEn {
	_TranslationsPagesPositionEditorSavedFileNameDialogFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Choisir le nom du fichier';
	@override String get name_placeholder => 'Nom du fichier';
}

// Path: pages.position_shortcuts.errors
class _TranslationsPagesPositionShortcutsErrorsFr implements TranslationsPagesPositionShortcutsErrorsEn {
	_TranslationsPagesPositionShortcutsErrorsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get failed_pasting_fen => 'Échec lors du collage du FEN';
}

// Path: pages.position_shortcuts.buttons
class _TranslationsPagesPositionShortcutsButtonsFr implements TranslationsPagesPositionShortcutsButtonsEn {
	_TranslationsPagesPositionShortcutsButtonsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get paste_fen => 'Coller le FEN';
	@override String get copy_fen => 'Copier le FEN';
	@override String get clear => 'Effacer';
	@override String get reset => 'Réinitialiser';
	@override String get set_start_position => 'Position de départ';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsFr {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'widgets.board_editor.black_turn': return 'Trait aux Noirs:';
			case 'widgets.position_information_form.white_player': return 'Joueur Blanc';
			case 'widgets.position_information_form.black_player': return 'Joueur Noir';
			case 'widgets.position_information_form.event': return 'Évènement';
			case 'widgets.position_information_form.date': return 'Date';
			case 'widgets.position_information_form.exercise': return 'Exercice';
			case 'pages.overall.buttons.ok': return 'Ok';
			case 'pages.overall.buttons.cancel': return 'Annuler';
			case 'pages.overall.buttons.save': return 'Sauvegarder';
			case 'pages.home.title': return 'Page principale';
			case 'pages.home.create_folder_dialog.title': return 'Créer un dossier';
			case 'pages.home.create_folder_dialog.folder_name_placeholder': return 'Nom du dossier';
			case 'pages.home.create_folder_errors.already_exists': return 'Le dossier existe déjà';
			case 'pages.home.create_folder_errors.creation_error': return 'Échec de création du dossier';
			case 'pages.home.misc_errors.failed_editing_position': return 'Échec d\'édition de la position';
			case 'pages.home.misc_errors.failed_viewing_position_details': return 'Échec de lecture des détails de la position';
			case 'pages.home.misc_errors.failed_deleting_position': return 'Échec de suppression de la position';
			case 'pages.home.misc_errors.failed_deleting_folder': return 'Échec de suppression du dossier';
			case 'pages.home.misc_errors.failed_opening_folder': return 'Échec d\'ouverture du dossier';
			case 'pages.home.misc_errors.failed_opening_position': return 'Échec d\'ouverture de la position';
			case 'pages.home.misc_errors.failed_reading_position_value': return ({required Object fileName}) => 'Échec de lecture de la position du fichier ${fileName}';
			case 'pages.home.delete_position_dialog.title': return 'Supprimer la position ?';
			case 'pages.home.delete_position_dialog.message': return ({required Object name}) => 'Êtes vous-sûr de vouloir supprimer la position ${name} ?';
			case 'pages.home.delete_folder_dialog.title': return 'Supprimer le dossier';
			case 'pages.home.delete_folder_dialog.message': return ({required Object name}) => 'Êtes vous-sûr de vouloir supprimer le dossier ${name} ?';
			case 'pages.home.rename_position_dialog.title': return ({required Object currentName}) => 'Renommer la position (${currentName})';
			case 'pages.home.rename_position_dialog.name_placeholder': return 'Nouveau nom';
			case 'pages.home.rename_position_errors.already_exists': return 'Le fichier existe déjà';
			case 'pages.home.rename_position_errors.modification_error': return 'Échec de modification du nom de fichier';
			case 'pages.home.rename_folder_errors.already_exists': return 'Le dossier existe déjà';
			case 'pages.home.rename_folder_errors.modification_error': return 'Échec de modification du nom de dossier';
			case 'pages.home.rename_folder_dialog.title': return ({required Object newFolderName}) => 'Renommer le dossier (${newFolderName})';
			case 'pages.home.rename_folder_dialog.name_placeholder': return 'Nouveau nom';
			case 'pages.home.misc.base_directory': return '[DOSSIER_DE_BASE]';
			case 'pages.home.misc.no_item': return 'Aucun élément';
			case 'pages.position_details.title': return ({required Object fileName}) => 'Détails de la position (${fileName})';
			case 'pages.position_editor.title': return ({required Object fileName}) => 'Éditeur de position (${fileName})';
			case 'pages.position_editor.simple_title': return 'Éditeur de position';
			case 'pages.position_editor.saved_file_name_dialog.title': return 'Choisir le nom du fichier';
			case 'pages.position_editor.saved_file_name_dialog.name_placeholder': return 'Nom du fichier';
			case 'pages.position_shortcuts.errors.failed_pasting_fen': return 'Échec lors du collage du FEN';
			case 'pages.position_shortcuts.buttons.paste_fen': return 'Coller le FEN';
			case 'pages.position_shortcuts.buttons.copy_fen': return 'Copier le FEN';
			case 'pages.position_shortcuts.buttons.clear': return 'Effacer';
			case 'pages.position_shortcuts.buttons.reset': return 'Réinitialiser';
			case 'pages.position_shortcuts.buttons.set_start_position': return 'Position de départ';
			default: return null;
		}
	}
}

