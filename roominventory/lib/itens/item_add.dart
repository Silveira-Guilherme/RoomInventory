import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:roominventory/appbar/appbar_back.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _idItemController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _condicaoController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _ultimaVerificacaoController = TextEditingController();

  List<dynamic> places = [];
  List<dynamic> zones = [];
  List<dynamic> filteredZones = [];
  String? selectedPlace;
  String? selectedZone;
  final List<Map<String, String>> _detailsList = [];
  bool isLoading = true;

  // New list to store dynamic input fields
  final List<Map<String, TextEditingController>> _dynamicInputs = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      var response = await http.post(
        Uri.parse('https://services.interagit.com/API/roominventory/api_ri.php'),
        body: {'query_param': 'P1'},
      );
      if (response.statusCode == 200) {
        setState(() {
          places = json.decode(response.body);
        });
      }

      response = await http.post(
        Uri.parse('https://services.interagit.com/API/roominventory/api_ri.php'),
        body: {'query_param': 'Z1'},
      );
      if (response.statusCode == 200) {
        setState(() {
          zones = json.decode(response.body);
          filteredZones = zones;
        });
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveItem() async {
    print("Saving item...");
    print(selectedZone);
    /*
    try {
      var response = await http.post(
        Uri.parse('https://services.interagit.com/API/roominventory/api_ri.php'),
        body: {
          'query_param': 'I2',
          'IdItem': _idItemController.text,
          'ItemName': _itemNameController,
          'FK_IdZone': selectedZone,
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          places = json.decode(response.body);
        });
      }

      response = await http.post(
        Uri.parse('https://services.interagit.com/API/roominventory/api_ri.php'),
        body: {'query_param': 'Z1'},
      );
      if (response.statusCode == 200) {
        setState(() {
          zones = json.decode(response.body);
          filteredZones = zones;
        });
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    */
  }

  void _addDetail() {
    final detail = {
      'Marca': _marcaController.text.trim(),
      'Condicao': _condicaoController.text.trim(),
      'Quantidade': _quantidadeController.text.trim(),
      'Tamanho': _tamanhoController.text.trim(),
      'Tipo': _tipoController.text.trim(),
      'Ultima Verificacao': _ultimaVerificacaoController.text.trim(),
    };

    if (detail.values.every((value) => value.isNotEmpty)) {
      setState(() {
        _detailsList.add(detail);
        _marcaController.clear();
        _condicaoController.clear();
        _quantidadeController.clear();
        _tamanhoController.clear();
        _tipoController.clear();
        _ultimaVerificacaoController.clear();
      });
    } else {
      _showErrorDialog('Please fill all detail fields.');
    }
  }

  void _filterZones(String? placeId) {
    setState(() {
      filteredZones = placeId == null ? zones : zones.where((zone) => zone['FK_IdPlace'] == placeId).toList();
      selectedZone = null;
    });
  }

  void _addDynamicInput() {
    setState(() {
      _dynamicInputs.add({
        'detalhe': TextEditingController(),
        'detalheName': TextEditingController(),
      });
    });
  }

  void _removeDynamicInput(int index) {
    setState(() {
      _dynamicInputs.removeAt(index);
    });
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showPlacePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: CupertinoColors.systemBackground,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: Text('Done'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedPlace = places[index]['IdPlace'];
                    _filterZones(selectedPlace);
                  });
                },
                children: places.map((place) => Text(place['PlaceName'])).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showZonePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: CupertinoColors.systemBackground,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: Text('Done'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedZone = filteredZones[index]['IdZone'];
                  });
                },
                children: filteredZones.map((zone) => Text(zone['ZoneName'])).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: AddNavigationBar(
        title: 'Itens',
        previousPageTitle: 'Inventário',
        onAddPressed: _saveItem,
      ),
      child: SafeArea(
        child: isLoading
            ? Center(child: CupertinoActivityIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Item Information Section
                    CupertinoFormSection(
                      header: Text(
                        "Informação do Item",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      children: [
                        CupertinoTextFormFieldRow(
                          controller: _idItemController,
                          placeholder: 'ID',
                          style: TextStyle(fontSize: 16),
                        ),
                        CupertinoTextFormFieldRow(
                          controller: _itemNameController,
                          placeholder: 'Nome',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                    // Location Section
                    CupertinoFormSection(
                      header: Text(
                        "Localização",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      children: [
                        CupertinoListTile(
                          title: Text("Lugar"),
                          trailing: CupertinoButton(
                            child: Text(selectedPlace != null ? places.firstWhere((place) => place['IdPlace'] == selectedPlace)['PlaceName'] : 'Select'),
                            onPressed: _showPlacePicker,
                          ),
                        ),
                        CupertinoListTile(
                          title: Text("Zona"),
                          trailing: CupertinoButton(
                            child: Text(selectedZone != null ? filteredZones.firstWhere((zone) => zone['IdZone'] == selectedZone)['ZoneName'] : 'Select'),
                            onPressed: _showZonePicker,
                          ),
                        ),
                      ],
                    ),

                    // Details Section
                    CupertinoFormSection(
                      header: Text(
                        "Item Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      children: [
                        CupertinoTextFormFieldRow(controller: _marcaController, placeholder: 'Marca'),
                        CupertinoTextFormFieldRow(controller: _tipoController, placeholder: 'Tipo'),
                        CupertinoTextFormFieldRow(controller: _quantidadeController, placeholder: 'Quantidade'),
                        CupertinoTextFormFieldRow(controller: _condicaoController, placeholder: 'Condição'),
                        CupertinoTextFormFieldRow(controller: _tamanhoController, placeholder: 'Tamanho'),
                        CupertinoTextFormFieldRow(controller: _ultimaVerificacaoController, placeholder: 'Última Verificação'),

                        // Dynamic Inputs Section (right below the Details Section)
                        ..._dynamicInputs.map((input) {
                          final index = _dynamicInputs.indexOf(input);
                          return Column(
                            children: [
                              Row(
                                children: [
                                  // Detalhe Input
                                  Expanded(
                                    child: CupertinoTextFormFieldRow(
                                      controller: input['detalhe'],
                                      placeholder: 'Detalhe',
                                    ),
                                  ),
                                  SizedBox(width: 5), // Add some spacing between the inputs
                                  // Detalhe Name Input
                                  Expanded(
                                    child: CupertinoTextFormFieldRow(
                                      controller: input['detalheName'],
                                      placeholder: 'Detalhe Name',
                                    ),
                                  ),
                                  SizedBox(width: 10), // Add some spacing between the inputs and the button
                                  // Remove Button (Trash Icon)
                                  CupertinoButton(
                                    padding: EdgeInsets.zero, // Remove default padding
                                    child: Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed),
                                    onPressed: () => _removeDynamicInput(index),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10), // Add some spacing between dynamic inputs
                            ],
                          );
                        }).toList(),
                        CupertinoListTile(
                          title: IconButton(
                            onPressed: _addDynamicInput,
                            icon: Icon(CupertinoIcons.add),
                          ),
                        ),
                      ],
                    ),

                    // Save Button
                    SizedBox(height: 20),
                    CupertinoButton.filled(
                      child: Text('Save Item'),
                      onPressed: _saveItem,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
