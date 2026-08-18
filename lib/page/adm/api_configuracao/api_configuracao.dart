import 'package:flutter/material.dart';
import 'package:pedidosdp/page/adm/relatorios/data/empresa_service.dart';

enum Empresa {
  santaCruz(id: 1, label: 'Santa Cruz'),
  caruaru(id: 2, label: 'Caruaru');

  const Empresa({required this.id, required this.label});

  final int id;
  final String label;
}

class ApiConfiguracao extends StatefulWidget {
  const ApiConfiguracao({super.key});

  @override
  State<ApiConfiguracao> createState() => _ApiConfiguracaoState();
}

class _ApiConfiguracaoState extends State<ApiConfiguracao> {
  final _formKey = GlobalKey<FormState>();
  final _baseUrlController = TextEditingController();
  final _apiTokenController = TextEditingController();
  late Empresa? _empresaSelecionada;
  bool _tokenVisivel = false;

  @override
  void initState() {
    super.initState();
    _empresaSelecionada = EmpresaService.instance.empresaAtual.value;
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _apiTokenController.dispose();
    super.dispose();
  }

  void _salvarConfiguracoes() {
    if (!_formKey.currentState!.validate()) return;
    if (_empresaSelecionada == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione uma cidade')));
      return;
    }

    final payload = {
      'baseUrl': _baseUrlController.text.trim(),
      'apiToken': _apiTokenController.text.trim(),
      'empresa': _empresaSelecionada!.id,
    };

    EmpresaService.instance.empresaAtual.value = _empresaSelecionada!;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Configurações salvas')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Api Configurações',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Aqui você pode configurar as informações da api para ambas as empresas. '
                  'Certifique-se de inserir os dados corretos para garantir o funcionamento adequado do sistema.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 25),
              _ConfigCard(
                title: 'Endereço do Servidor',
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: _LabeledField(
                          label: 'Base URL',
                          child: TextFormField(
                            controller: _baseUrlController,
                            decoration: _campoDecoration(
                              hintText: 'https://187.164.196/api/teste',
                            ),
                            // validator: (value) =>
                            //     (value == null || value.trim().isEmpty)
                            //     ? 'Informe a Base URL'
                            //     : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: _LabeledField(
                          label: 'Cidade',
                          child: DropdownButtonFormField<Empresa>(
                            decoration: _campoDecoration(),
                            initialValue: _empresaSelecionada,
                            items: Empresa.values
                                .map(
                                  (empresa) => DropdownMenuItem(
                                    value: empresa,
                                    child: Text(empresa.label),
                                  ),
                                )
                                .toList(),
                            onChanged: (novoValor) {
                              setState(() => _empresaSelecionada = novoValor);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _ConfigCard(
                title: 'Segurança',
                children: [
                  _LabeledField(
                    label: 'API Token (Bearer)',
                    child: TextFormField(
                      controller: _apiTokenController,
                      obscureText: !_tokenVisivel,
                      decoration: _campoDecoration(hintText: '**************')
                          .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _tokenVisivel
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() => _tokenVisivel = !_tokenVisivel);
                              },
                            ),
                          ),
                      // validator: (value) =>
                      //     (value == null || value.trim().isEmpty)
                      //     ? 'Informe o token'
                      //     : null,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _salvarConfiguracoes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0043AC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(
                          Icons.save_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Salvar Configurações',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _campoDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 5),
        child,
      ],
    );
  }
}

class _ConfigCard extends StatelessWidget {
  const _ConfigCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 240, 242, 245),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromARGB(255, 163, 165, 167),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Divider(color: Colors.grey[300], thickness: 1, height: 20),
          const SizedBox(height: 5),
          ...children,
        ],
      ),
    );
  }
}
