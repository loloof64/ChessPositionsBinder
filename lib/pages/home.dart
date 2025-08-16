import 'dart:io';

import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chess_position_binder/core/read_positions.dart';
import 'package:chess_position_binder/pages/dropbox.dart';
import 'package:chess_position_binder/pages/position_details.dart';
import 'package:chess_position_binder/pages/position_editor.dart';
import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart' as chess;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ionicons/ionicons.dart';

const parentFolder = '@ParentFolder@';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Directory? _currentDirectory;
  Directory? _baseDirectory;
  bool _contentIsReady = false;
  Future<List<RawFolderElement>> _contentFuture = Future.value([]);
  final ScrollController _scrollController = ScrollController();
  List<RawFolderElement>? _lastContentsState;

  @override
  void initState() {
    super.initState();
    _setupCurrentDirectory().then((_) => _reloadContent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _reloadContent() async {
    setState(() {
      _contentIsReady = false;
      _lastContentsState = null;
      _contentFuture = readElements(_currentDirectory!);
    });
    _contentFuture.then((value) {
      final usedContent = _filterUnwantedFolders(value);

      setState(() {
        _lastContentsState = usedContent;
        _contentIsReady = true;
      });
    });
  }

  Future<void> _setupCurrentDirectory() async {
    _currentDirectory = await getApplicationDocumentsDirectory();
    _baseDirectory = _currentDirectory;
    _contentFuture = readElements(_currentDirectory!);
  }

  Future<void> _purposeCreatePosition() async {
    final result = await Navigator.of(context).push<(String, String)?>(
      MaterialPageRoute(
        builder: (context) {
          final contentsNames = _getCurrentPositionsNames();
          return PositionEditorPage(
            fileName: "",
            initialFen: chess.Chess.initial.fen,
            editingExistingFile: false,
            alreadyExistingNames: contentsNames,
          );
        },
      ),
    );
    if (result == null) {
      return;
    }

    final (pgn, selectedName) = result;

    final savedFile = File("${_currentDirectory!.path}/$selectedName");
    await savedFile.writeAsString(pgn);

    _reloadContent();
  }

  List<String> _getCurrentPositionsNames() {
    if (_contentIsReady) {
      if (_lastContentsState == null) {
        throw "Current page content is not yet ready !";
      }
      return _lastContentsState!
          .where((elt) {
            return !elt.isFolder;
          })
          .toList()
          .map((elt) => elt.name.split("/").last)
          .toList();
    } else {
      return [];
    }
  }

  Future<void> _purposeCreateFolder() async {
    String newName = "";
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(t.pages.home.create_folder_dialog.title),
              content: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText:
                      t.pages.home.create_folder_dialog.folder_name_placeholder,
                ),
                controller: TextEditingController(text: ""),
                onChanged: (value) {
                  newName = value;
                },
              ),
              actions: [
                TextButton(
                  child: Text(
                    t.misc.buttons.cancel,
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    t.misc.buttons.ok,
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _createFolder(newName);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _createFolder(String name) async {
    try {
      final usedName = name.trim();
      final newFolder = Directory("${_currentDirectory!.path}/$usedName");
      if (await newFolder.exists()) {
        throw Exception(t.pages.home.create_folder_errors.already_exists);
      }
      await newFolder.create();
      _reloadContent();
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.pages.home.create_folder_errors.creation_error),
        ),
      );
    }
  }

  Future<void> _purposeEditPosition(String path) async {
    try {
      final fileName = path.split(Platform.pathSeparator).last;
      final pgnContent = await File(path).readAsString();
      final chessGame = chess.PgnGame.parsePgn(pgnContent);
      final initialFen = chessGame.headers["FEN"] ?? chess.Chess.initial.fen;
      final whitePlayer = chessGame.headers["White"] ?? "";
      final blackPlayer = chessGame.headers["Black"] ?? "";
      final event = chessGame.headers["Event"] ?? "";
      final date = chessGame.headers["Date"] ?? "";
      final exercice = chessGame.headers["Exercice"] ?? "";
      if (!context.mounted) {
        return;
      }
      final result = await Navigator.of(context).push<(String, String)?>(
        MaterialPageRoute(
          builder: (context) {
            return PositionEditorPage(
              fileName: fileName,
              initialFen: initialFen,
              editingExistingFile: true,
              whitePlayer: whitePlayer,
              blackPlayer: blackPlayer,
              event: event,
              date: date,
              exercice: exercice,
              alreadyExistingNames: [], // has no importance here
            );
          },
        ),
      );
      if (result == null) {
        return;
      }

      final (newPgn, _) = result;
      final savedFile = File(path);
      await savedFile.writeAsString(newPgn);

      _reloadContent();
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.pages.home.misc_errors.failed_editing_position),
        ),
      );
    }
  }

  Future<void> _purposeViewPositionDetails(String path) async {
    try {
      final fileName = path.split(Platform.pathSeparator).last;
      final pgnContent = await File(path).readAsString();
      final chessGame = chess.PgnGame.parsePgn(pgnContent);
      final initialFen = chessGame.headers["FEN"] ?? chess.Chess.initial.fen;
      final whitePlayer = chessGame.headers["White"] ?? "NN";
      final blackPlayer = chessGame.headers["Black"] ?? "NN";
      final event = chessGame.headers["Event"] ?? "?";
      final date = chessGame.headers["Date"] ?? "????.??.??";
      final exercice = chessGame.headers["Exercice"] ?? "";
      if (!context.mounted) {
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return PositionDetailsPage(
              fileName: fileName,
              fen: initialFen,
              whitePlayer: whitePlayer,
              blackPlayer: blackPlayer,
              event: event,
              date: date,
              exercice: exercice,
            );
          },
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.pages.home.misc_errors.failed_viewing_position_details,
          ),
        ),
      );
    }
  }

  Future<void> _purposeDeletePosition(String path) async {
    final name = path.split(Platform.pathSeparator).last;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.pages.home.delete_position_dialog.title),
          content: Text(
            t.pages.home.delete_position_dialog.message(name: name),
          ),
          actions: [
            TextButton(
              child: Text(
                t.misc.buttons.cancel,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                t.misc.buttons.ok,
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deletePosition(path);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _purposeDeleteFolder(String path) async {
    final name = path.split(Platform.pathSeparator).last;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.pages.home.delete_folder_dialog.title),
          content: Text(t.pages.home.delete_folder_dialog.message(name: name)),
          actions: [
            TextButton(
              child: Text(
                t.misc.buttons.cancel,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                t.misc.buttons.ok,
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteFolder(path);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePosition(String path) async {
    try {
      final savedFile = File(path);
      await savedFile.delete();
      _reloadContent();
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.pages.home.misc_errors.failed_deleting_position),
        ),
      );
    }
  }

  Future<void> _deleteFolder(String path) async {
    try {
      final savedFolder = Directory(path);
      await savedFolder.delete(recursive: true);
      _reloadContent();
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.pages.home.misc_errors.failed_deleting_folder),
        ),
      );
    }
  }

  Future<void> _purposeRenamePosition(String path) async {
    final currentName = path.split(Platform.pathSeparator).last;
    List<String> currentNameParts = currentName.split(".");
    currentNameParts.removeLast();
    final currentNameWithoutExtension = currentNameParts.join(".");
    String currentValue = currentNameWithoutExtension;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                t.pages.home.rename_position_dialog.title(
                  currentName: currentName,
                ),
              ),
              content: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText:
                      t.pages.home.rename_position_dialog.name_placeholder,
                ),
                controller: TextEditingController(text: currentValue),
                onChanged: (value) => currentValue = value,
              ),
              actions: [
                TextButton(
                  child: Text(
                    t.misc.buttons.cancel,
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    t.misc.buttons.ok,
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    String newName = currentValue;
                    if (!newName.endsWith(".pgn")) {
                      newName += ".pgn";
                    }
                    await _renamePosition(path, newName);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _renamePosition(String path, String newName) async {
    try {
      final savedFile = File(path);
      final newSavedFile = File("${_currentDirectory!.path}/$newName");
      if (await newSavedFile.exists()) {
        throw Exception(t.pages.home.rename_position_errors.already_exists);
      }
      await savedFile.rename(newSavedFile.path);
      _reloadContent();
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.pages.home.rename_position_errors.modification_error),
        ),
      );
    }
  }

  Future<void> _renameFolder(String path, String newName) async {
    try {
      final savedFolder = Directory(path);
      final newSavedFolder = Directory("${_currentDirectory!.path}/$newName");
      if (await newSavedFolder.exists()) {
        throw Exception(t.pages.home.rename_folder_errors.already_exists);
      }
      await savedFolder.rename(newSavedFolder.path);
      _reloadContent();
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.pages.home.rename_folder_errors.modification_error),
        ),
      );
    }
  }

  Future<void> _handleFolderSelection(String name) async {
    if (name == parentFolder) {
      setState(() {
        _currentDirectory = _currentDirectory!.parent;
      });
      _reloadContent();
      return;
    }
    try {
      final matchingFile = File("${_currentDirectory!.path}/$name");
      if (!await FileSystemEntity.isDirectory(matchingFile.path)) {
        return;
      }
      setState(() {
        _currentDirectory = Directory(matchingFile.path);
      });
      _reloadContent();
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.pages.home.misc_errors.failed_opening_folder)),
      );
    }
  }

  Future<void> _handlePositionSelection(String path) async {
    try {
      if (!await FileSystemEntity.isFile(path)) {
        return;
      }
      _purposeViewPositionDetails(path);
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.pages.home.misc_errors.failed_opening_position),
        ),
      );
    }
  }

  Future<void> _purposeRenameFolder(String path) async {
    showDialog(
      context: context,
      builder: (context) {
        String newFolderName = path.split(Platform.pathSeparator).last;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                t.pages.home.rename_folder_dialog.title(
                  newFolderName: newFolderName,
                ),
              ),
              content: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: t.pages.home.rename_folder_dialog.name_placeholder,
                ),
                controller: TextEditingController(text: newFolderName),
                onChanged: (value) => newFolderName = value,
              ),
              actions: [
                TextButton(
                  child: Text(
                    t.misc.buttons.cancel,
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    t.misc.buttons.ok,
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _renameFolder(path, newFolderName.trim());
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _accessDropbox() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DropboxPage();
        },
      ),
    );
  }

  List<RawFolderElement> _filterUnwantedFolders(
    List<RawFolderElement> elements,
  ) {
    final isAndroid = Platform.isAndroid;
    final isBaseFolder =
        (_currentDirectory?.path == _baseDirectory?.path) &&
        (_currentDirectory != null);

    final usedContent = (isAndroid && isBaseFolder)
        ? elements
              .where(
                (elt) =>
                    !elt.isFolder ||
                    elt.name.split("/").last != "flutter_assets",
              )
              .toList()
        : elements;

    return usedContent;
  }

  @override
  Widget build(BuildContext context) {
    var pathText = _currentDirectory?.path ?? "";
    if (_currentDirectory != null && _baseDirectory != null) {
      pathText = pathText.replaceFirst(
        _baseDirectory!.path,
        t.pages.home.misc.base_directory,
      );
    }
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final width = MediaQuery.sizeOf(context).width;
    final boardSize = isPortrait ? width * 0.4 : width * 0.28;
    final content = FutureBuilder<List<RawFolderElement>>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var allItems = snapshot.data!;
          if (_currentDirectory?.path != _baseDirectory?.path) {
            allItems = [
              RawFolderElement(name: parentFolder, content: "", isFolder: true),
              ...allItems,
            ];
          }
          allItems = _filterUnwantedFolders(allItems);
          return allItems.isEmpty && _currentDirectory == _baseDirectory
              ? Text(t.pages.home.misc.no_item)
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: allItems.length,
                    itemBuilder: (context, index) {
                      final currentItem = allItems[index];
                      final itemPath = currentItem.name;
                      final itemName = itemPath.split('/').last;
                      final itemPgn = currentItem.content;
                      final isFolder = currentItem.isFolder;
                      final isParentFolder =
                          isFolder && itemPath == parentFolder;
                      if (isParentFolder) {
                        return GestureDetector(
                          onTap: () => _handleFolderSelection(parentFolder),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 50,
                                color: Colors.blueAccent,
                              ),
                            ],
                          ),
                        );
                      } else if (isFolder) {
                        return GestureDetector(
                          onTap: () => _handleFolderSelection(itemName),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 2,
                            children: [
                              Icon(
                                Icons.folder,
                                size: 50,
                                color: Colors.amberAccent,
                              ),
                              Text(itemName),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        _purposeRenameFolder(itemPath),
                                    icon: Icon(Icons.abc),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _purposeDeleteFolder(itemPath),
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        try {
                          final pgnGame = chess.PgnGame.parsePgn(itemPgn);
                          final position = chess.PgnGame.startingPosition(
                            pgnGame.headers,
                          );
                          final itemOrientation =
                              position.turn == chess.Side.white
                              ? chess.Side.white
                              : chess.Side.black;
                          final turnColor = position.turn == chess.Side.white
                              ? Colors.white
                              : Colors.black;
                          final turnSize = 30.0;
                          return GestureDetector(
                            onTap: () => _handlePositionSelection(itemPath),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 4,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: StaticChessboard(
                                    pieceAssets: PieceSet.meridaAssets,
                                    size: boardSize,
                                    fen: position.fen,
                                    orientation: itemOrientation,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 5,
                                  children: [
                                    Text(itemName),
                                    Container(
                                      width: turnSize,
                                      height: turnSize,
                                      decoration: BoxDecoration(
                                        color: turnColor,
                                        border: BoxBorder.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.abc),
                                      onPressed: () =>
                                          _purposeRenamePosition(itemPath),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () =>
                                          _purposeEditPosition(itemPath),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () =>
                                          _purposeDeletePosition(itemPath),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          debugPrint(e.toString());
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                t.pages.home.misc_errors
                                    .failed_reading_position_value(
                                      fileName: itemName,
                                    ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () =>
                                        _purposeEditPosition(itemPath),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        _purposeDeletePosition(itemPath),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      }
                    },
                  ),
                );
        } else if (snapshot.hasError) {
          return Icon(Icons.error, color: Colors.red);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );

    var screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(t.pages.home.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_drive_file_outlined),
            onPressed: () {
              _purposeCreatePosition();
            },
          ),
          IconButton(onPressed: _purposeCreateFolder, icon: Icon(Icons.folder)),
          IconButton(onPressed: _reloadContent, icon: Icon(Icons.refresh)),
          IconButton(
            onPressed: _accessDropbox,
            icon: Icon(Ionicons.logo_dropbox),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth,
            color: Colors.amberAccent,
            child: Scrollbar(
              thumbVisibility: true,
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Text(
                  pathText,
                  softWrap: false,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Flexible(child: content),
        ],
      ),
    );
  }
}
