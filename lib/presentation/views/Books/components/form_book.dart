import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:library_flutter/app/controllers/BookController/book_controller.dart';
import 'package:library_flutter/app/controllers/PublisherController/publisher_controller.dart';
import 'package:library_flutter/app/controllers/ThemeController/theme_controller.dart';
import 'package:library_flutter/domain/models/Book/book.dart';
import 'package:library_flutter/domain/models/Publisher/publisher.dart';
import 'package:library_flutter/presentation/components/AppBar/custom_appbar.dart';
import 'package:library_flutter/presentation/components/FormInput/form_input.dart';
import 'package:library_flutter/presentation/components/ReturnButton/return_button.dart';
import 'package:library_flutter/presentation/components/SelectInput/select_input.dart';

class FormBook extends StatefulWidget {
  final String? id;
  final String? name;
  final String? author;
  final String? publisherId;
  final String? realeaseYear;
  final String? quantity;

  const FormBook({
    Key? key,
    this.id,
    this.name,
    this.author,
    this.publisherId,
    this.realeaseYear,
    this.quantity,
  }) : super(key: key);

  @override
  State<FormBook> createState() => _FormBookState();
}

class _FormBookState extends State<FormBook> {
  final storeBook = Modular.get<BookController>();
  final storePublisher = Modular.get<PublisherController>();
  final storeTheme = Modular.get<ThemeController>();

  final formKey = GlobalKey<FormState>();
  final formData = <String, String>{};

  final nameFocus = FocusNode();
  final cityFocus = FocusNode();
  final quantityFocus = FocusNode();
  final realeaseYearFocus = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (formData.isEmpty) {
      if (widget.id != null) {
        formData["id"] = widget.id!;
      }
      if (widget.name != null) {
        formData["name"] = widget.name!;
      }
      if (widget.author != null) {
        formData["author"] = widget.author!;
      }
      if (widget.publisherId != null) {
        formData["publisherId"] = widget.publisherId!;
      }
      if (widget.realeaseYear != null) {
        formData["realeaseYear"] = widget.realeaseYear!;
      }
      if (widget.quantity != null) {
        formData["quantity"] = widget.quantity!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void _onSubmit() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final isValid = formKey.currentState?.validate() ?? false;

        if (!isValid) {
          return;
        } else {
          formKey.currentState?.save();

          if (formData["id"] != null && formData["id"] != "") {
            final book = Book(
              id: formData['id'],
              name: formData["name"],
              author: formData["author"],
              quantity: formData["quantity"],
              realeaseYear: formData['realeseYear'],
              publisher: Publisher(
                id: formData['publisherId'],
                name: '',
                city: '',
              ),
            );

            storeBook.updateBook(book);
          } else {
            final book = Book(
              name: formData["name"],
              author: formData["author"],
              quantity: formData["quantity"],
              realeaseYear: formData['realeseYear'],
              publisher: Publisher(
                id: formData['publisherId'],
                name: '',
                city: '',
              ),
            );

            storeBook.createBook(book);
          }
        }
      });
    }

    return Observer(
      builder: (_) => Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReturnButton(
                title: widget.id!.isNotEmpty ? "Editar Livro" : "Criar Livro",
                backRoute: '/books/',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      FormInput(
                        title: 'Nome',
                        initialValue: formData['name'],
                        icon: const Icon(Icons.abc),
                        margin: 10.0,
                        focus: nameFocus,
                        changeFocus: cityFocus,
                        onSave: (name) => {
                          setState(() => {
                                formData['name'] = name ?? '',
                              })
                        },
                        validator: (text) {
                          final name = text ?? '';

                          if (name.trim().isEmpty) {
                            return 'Nome é obrigatório';
                          }

                          return null;
                        },
                      ),
                      FormInput(
                        title: 'Autor',
                        initialValue: formData['author'],
                        icon: const Icon(Icons.person),
                        margin: 10.0,
                        focus: cityFocus,
                        onSave: (author) => {
                          setState(() => {
                                formData['author'] = author ?? '',
                              })
                        },
                        validator: (text) {
                          final author = text ?? '';

                          if (author.trim().isEmpty) {
                            return 'Autor é obrigatório';
                          }

                          return null;
                        },
                      ),
                      FormInput(
                        title: 'Quantidade',
                        inputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: formData['quantity'],
                        icon: const Icon(Icons.archive),
                        textInputType: TextInputType.number,
                        margin: 10.0,
                        focus: quantityFocus,
                        onSave: (quantity) => {
                          setState(() => {
                                formData['quantity'] = quantity ?? '',
                              })
                        },
                        validator: (text) {
                          final quantity = text ?? '';

                          if (quantity.trim().isEmpty) {
                            return 'Quantidade é obrigatório';
                          }

                          if (int.parse(quantity) < 0) {
                            return 'Quantidade invalidade';
                          }

                          return null;
                        },
                      ),
                      FormInput(
                        title: 'Ano de lançamento',
                        inputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: formData['realeaseYear'],
                        textInputType: TextInputType.number,
                        icon: const Icon(Icons.calendar_month),
                        margin: 10.0,
                        focus: realeaseYearFocus,
                        onSave: (realeaseYear) => {
                          setState(() => {
                                formData['realeseYear'] = realeaseYear ?? '',
                              })
                        },
                        validator: (text) {
                          final realeaseYear = text ?? '';

                          if (realeaseYear.trim().isEmpty) {
                            return 'Quantidade é obrigatório';
                          }

                          if (realeaseYear.length < 3 ||
                              realeaseYear.length > 4) {
                            return 'Informe uma data valida';
                          }
                          return null;
                        },
                      ),
                      SelectInput(
                        title: 'Editoras',
                        value: formData['publisherId'],
                        list: storePublisher.publishers,
                        onChange: (String? publisherId) => {
                          setState(() => {
                                formData['publisherId'] = publisherId ?? '',
                              }),
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 40,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            gradient: LinearGradient(colors: [
                              Colors.deepPurple,
                              Colors.purple,
                              Colors.deepPurple
                            ])),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              shadowColor: Colors.transparent),
                          onPressed: _onSubmit,
                          child: const Text(
                            'Salvar',
                            style: TextStyle(color: Colors.white),
                          ),
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
}
