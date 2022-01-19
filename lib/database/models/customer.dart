class Customers {
  final int? id;
  final String nome;
  final String sobrenome;
  final String email;
  final String? order;
  final String? urlFile;

  Customers(
      {this.id,
      required this.nome,
      required this.sobrenome,
      required this.email,
      this.order,
      this.urlFile});

  @override
  String toString() {
    return 'Customers{id: $id, nome: $nome, sobrenome: $sobrenome, email: $email, order: $order, url_file: $urlFile}';
  }

  factory Customers.fromJson(Map<String, dynamic> json) {
    return Customers(
      id: int.parse(json["id"].toString()),
      nome: json["nome"],
      sobrenome: json["sobrenome"],
      email: json["email"],
      urlFile: json["url_file"].toString().replaceAll("\\", "/"),
      order: json["nome"].toString().toUpperCase().substring(0, 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "nome": this.nome,
      "sobrenome": this.sobrenome,
      "email": this.email,
    };
  }

//

}
