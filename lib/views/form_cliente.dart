import 'dart:io';

import 'package:app_customers/constantes/url_api.dart';
import 'package:app_customers/database/models/customer.dart';
import 'package:app_customers/database/reporitory/customers_repository.dart';
import 'package:app_customers/views/components/botao.dart';
import 'package:app_customers/views/components/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class FormCustomers extends StatefulWidget {
  final Customers? customer;

  const FormCustomers({Key? key, this.customer}) : super(key: key);

  @override
  _FormCustomersState createState() => _FormCustomersState();
}

class _FormCustomersState extends State<FormCustomers> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerSobre = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  bool _isAlterar = false;
  bool _isFileRemove = false;
  final CustomersRepository _repository = CustomersRepository();
  File? _image;

  @override
  Widget build(BuildContext context) {
    final bool _novo = widget.customer == null;
    if (!_novo) {
      _preencherDados(widget.customer);
    } else {
      _isAlterar = true;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: Text(
          _novo ? "Novo Cliente" : "Editar Cliente",
          style: TextStyle(color: Colors.black),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        child: _ImageCli(),
                      ),
                      Input(
                        hint: "Nome",
                        textEditingAction: _controllerNome,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Verifique o campo";
                          }
                        },
                        enabled: _isAlterar,
                      ),
                      const SizedBox(height: 10),
                      Input(
                        hint: "Sobrenome",
                        textEditingAction: _controllerSobre,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Verifique o campo";
                          }
                        },
                        enabled: _isAlterar,
                      ),
                      const SizedBox(height: 10),
                      Input(
                        hint: "Email",
                        textEditingAction: _controllerEmail,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Verifique o campo";
                          }
                        },
                        enabled: _isAlterar,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Botao(
                                hint: _novo ? "Cancelar" : "Remover",
                                icone: _novo
                                    ? Icons.cancel_outlined
                                    : Icons.delete,
                                click: () async {
                                  if (!_novo) {
                                    _deletar();
                                  } else {
                                    Navigator.pop(context, 'ok');
                                  }
                                },
                                color: Colors.redAccent,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Botao(
                                hint: _isAlterar ? "Salvar" : "Alterar",
                                icone: _isAlterar
                                    ? Icons.save
                                    : Icons.add_to_home_screen,
                                click: () async {
                                  if (_isAlterar) {
                                    if (_formKey.currentState!.validate()) {
                                      EasyLoading.show(
                                        status: 'Aguarde...',
                                        maskType: EasyLoadingMaskType.black,
                                      );
                                      final Customers? obj;
                                      if (_novo) {
                                        obj = await _repository.save(
                                          image: _image,
                                          customer: Customers(
                                            nome: _controllerNome.text,
                                            sobrenome: _controllerSobre.text,
                                            email: _controllerEmail.text,
                                          ),
                                        );
                                      } else {
                                        obj = await _repository.update(
                                          image: _image != null
                                              ? _image
                                              : _image == null &&
                                                      widget.customer != null &&
                                                      widget.customer!
                                                              .urlFile !=
                                                          null &&
                                                      widget.customer!.urlFile!
                                                          .isNotEmpty &&
                                                      !_isFileRemove
                                                  ? await _repository
                                                      .fileFromImageUrl(
                                                          urlFile: widget
                                                              .customer!
                                                              .urlFile,
                                                          id: widget
                                                              .customer!.id)
                                                  : null,
                                          customer: Customers(
                                            id: widget.customer!.id,
                                            nome: _controllerNome.text,
                                            sobrenome: _controllerSobre.text,
                                            email: _controllerEmail.text,
                                          ),
                                        );
                                      }
                                      EasyLoading.dismiss();
                                      Navigator.pop(context, "sucess");
                                    }
                                  } else {
                                    setState(() {
                                      _isAlterar = !_isAlterar;
                                    });
                                  }
                                },
                                color: Colors.blueAccent,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deletar() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Deseja Remover Cliente?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancela'),
          ),
          TextButton(
            onPressed: () async {
              EasyLoading.show(
                status: 'Aguarde...',
                maskType: EasyLoadingMaskType.black,
              );
              await _repository.delete(id: widget.customer!.id);
              EasyLoading.dismiss();
              Navigator.pop(context, 'ok');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    ).then((value) {
      if (value.toString() == 'ok') {
        Navigator.pop(context, 'ok');
      }
    });
  }

  // pegar foto da camera
  Future _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);
    setState(() {
      _image = File(image!.path);
      _isFileRemove = false;
    });
  }

  Future _getGaleria() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      _image = File(image!.path);
      _isFileRemove = false;
    });
  }

  Future _getRemover() async {
    setState(() {
      _isFileRemove = true;
      _image = null;
    });
  }

// escolher imagem ou camera
  _opImagem() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Selecionar Imagem'),
                Expanded(
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 25,
                    ),
                    onPressed: () {
                      _getRemover();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.camera,
                            size: 35,
                          ),
                          onPressed: () {
                            _getImage();
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Camera'),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.image,
                            size: 35,
                          ),
                          onPressed: () {
                            _getGaleria();
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Galeria')
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'))
            ],
          );
        });
  }

  void _preencherDados(Customers? customer) {
    _controllerNome.text = customer!.nome;
    _controllerSobre.text = customer.sobrenome;
    _controllerEmail.text = customer.email;
  }

  Widget _ImageCli() {
    return InkWell(
      child: _image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.file(
                _image!,
                fit: BoxFit.cover,
              ),
            )
          : widget.customer != null &&
                  widget.customer!.urlFile != null &&
                  widget.customer!.urlFile!.isNotEmpty &&
                  !_isFileRemove
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    hostApi + '${widget.customer!.urlFile}',
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.camera_alt,
                  size: 100,
                  color: Colors.black45,
                ),
      onTap: () {
        if (_isAlterar) {
          _opImagem();
        }
      },
    );
  }
}
