import 'package:app_customers/constantes/url_api.dart';
import 'package:app_customers/database/models/customer.dart';
import 'package:app_customers/database/reporitory/customers_repository.dart';
import 'package:app_customers/views/components/centered_message.dart';
import 'package:app_customers/views/form_cliente.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CustomersRepository _repository = CustomersRepository();
  final TextEditingController _controllerPesquisar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: false,
        title: Text(
          'Clientes',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      //   drawer: const NavDrawer(),
      body: LayoutBuilder(
          builder: (context, constraints) => RefreshIndicator(
              color: Colors.blueAccent,
              backgroundColor: Colors.white12,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: TextFormField(
                            onFieldSubmitted: (x) {
                              setState(() {});
                            },
                            textInputAction: TextInputAction.search,
                            controller: _controllerPesquisar,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Pesquisar clientes...',
                              labelStyle: const TextStyle(
                                fontFamily: 'Lexend Deca',
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white12,
                              contentPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      24, 20, 20, 20),
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 24,
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: 'Lexend Deca',
                            ),
                            onChanged: (x) async {},
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: FutureBuilder<List<Customers>>(
                          future: _repository.filter(
                              filter: _controllerPesquisar.text),
                          builder: (context, AsyncSnapshot snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                break;
                              case ConnectionState.waiting:
                                return const Center(
                                  child: LinearProgressIndicator(),
                                );
                              case ConnectionState.active:
                                break;
                              case ConnectionState.done:
                                if (snapshot.hasData) {
                                  final List<Customers> _customesrs =
                                      snapshot.data;
                                  if (_customesrs.isNotEmpty) {
                                    return GroupedListView<Customers, String>(
                                      shrinkWrap: true,
                                      elements: _customesrs,
                                      groupBy: (Customers customer) {
                                        return customer.order ?? '*';
                                      },
                                      groupSeparatorBuilder: (String value) =>
                                          Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Text(
                                              value,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      itemBuilder: (context, customer) {
                                        return Card(
                                          elevation: 8.0,
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0),
                                            leading: customer.urlFile == null ||
                                                    customer.urlFile!.isEmpty
                                                ? const Icon(
                                                    Icons.account_circle,
                                                    size: 40,
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    child: Image.network(
                                                      hostApi +
                                                          '${customer.urlFile}',
                                                      height: 250,
                                                      width: 50.0,
                                                    ),
                                                  ),
                                            title: Text(
                                                '${customer.nome} ${customer.sobrenome}'),
                                            subtitle: Text(customer.email),
                                            trailing:
                                                const Icon(Icons.arrow_forward),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FormCustomers(
                                                            customer: customer,
                                                          ))).then((value) => {
                                                    setState(() {
                                                      if(value.toString() == 'sucess'){
                                                        _getMesagem();
                                                      }
                                                    })
                                                  });
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  }
                                }

                                return CenteredMessage(
                                  'Nenhum Cliente encontrado',
                                  icon: Icons.warning,
                                  fontSize: 17,
                                  iconSize: 30,
                                );
                            }
                            return CenteredMessage("Unkown error");
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onRefresh: () async {
                setState(() {
                  _controllerPesquisar.text = "";
                });
              })),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FormCustomers()))
              .then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _getMesagem(){
    final snackBar = SnackBar(
      content: const Text(
          'Cliente salvo com sucesso!'),
      action: SnackBarAction(
        label: 'Ok',
        textColor:
        Colors.white,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
      behavior:
      SnackBarBehavior
          .floating,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius
            .circular(24),
      ),
      backgroundColor:
      Colors.green,
    );
    ScaffoldMessenger.of(
        context)
        .showSnackBar(
        snackBar);
  }
}
