import 'package:flutter/material.dart';
import 'package:pedidosdp/page/adm/adm_page.dart';

import 'pedidos/home_page.dart';
import 'corte/corte_industrial_home_page.dart';

enum TipoUsuario { operadores, corte, adm }

class SelecaoPerfilPage extends StatefulWidget {
  const SelecaoPerfilPage({super.key});

  @override
  State<SelecaoPerfilPage> createState() => _SelecaoPerfilPageState();
}

class _SelecaoPerfilPageState extends State<SelecaoPerfilPage> {
  static const String _senhaCorte = '1234';
  static const String _senhaAdm = '2069';

  final _formKey = GlobalKey<FormState>();
  final _senhaControllerCorte = TextEditingController();
  final _senhaControllerAdm = TextEditingController();

  TipoUsuario? _tipoSelecionado;

  bool _senhaVisivelCorte = false;
  bool _senhaVisivelAdm = false;
  bool _senhaErradaCorte = false;
  bool _senhaErradaAdm = false;

  @override
  void dispose() {
    _senhaControllerCorte.dispose();
    _senhaControllerAdm.dispose();
    super.dispose();
  }

  void _resetarEstadoSenhas() {
    _senhaControllerCorte.clear();
    _senhaControllerAdm.clear();
    _senhaErradaCorte = false;
    _senhaErradaAdm = false;
  }

  void _entrar() {
    if (!_formKey.currentState!.validate()) return;

    switch (_tipoSelecionado) {
      case TipoUsuario.operadores:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;

      case TipoUsuario.corte:
        if (_senhaControllerCorte.text == _senhaCorte) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CorteIndustrialHomePage()),
          );
        } else {
          setState(() => _senhaErradaCorte = true);
        }
        break;

      case TipoUsuario.adm:
        if (_senhaControllerAdm.text == _senhaAdm) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdmPage()),
          );
        } else {
          setState(() => _senhaErradaAdm = true);
        }
        break;

      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Selecione o perfil',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  DropdownButtonFormField<TipoUsuario>(
                    initialValue: _tipoSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de usuário',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: TipoUsuario.operadores,
                        child: Text('Operadores'),
                      ),
                      DropdownMenuItem(
                        value: TipoUsuario.corte,
                        child: Text('Corte Industrial'),
                      ),
                      DropdownMenuItem(
                        value: TipoUsuario.adm,
                        child: Text('Adm'),
                      ),
                    ],
                    validator: (value) =>
                        value == null ? 'Selecione um tipo de usuário' : null,
                    onChanged: (value) {
                      setState(() {
                        _tipoSelecionado = value;
                        _resetarEstadoSenhas();
                      });
                    },
                  ),

                  if (_tipoSelecionado == TipoUsuario.corte) ...[
                    const SizedBox(height: 16),
                    _SenhaField(
                      controller: _senhaControllerCorte,
                      visivel: _senhaVisivelCorte,
                      erro: _senhaErradaCorte ? 'Senha incorreta' : null,
                      onToggleVisivel: () => setState(
                        () => _senhaVisivelCorte = !_senhaVisivelCorte,
                      ),
                      onChanged: () {
                        if (_senhaErradaCorte) {
                          setState(() => _senhaErradaCorte = false);
                        }
                      },
                      onSubmitted: _entrar,
                    ),
                  ],

                  if (_tipoSelecionado == TipoUsuario.adm) ...[
                    const SizedBox(height: 16),
                    _SenhaField(
                      controller: _senhaControllerAdm,
                      visivel: _senhaVisivelAdm,
                      erro: _senhaErradaAdm ? 'Senha incorreta' : null,
                      onToggleVisivel: () =>
                          setState(() => _senhaVisivelAdm = !_senhaVisivelAdm),
                      onChanged: () {
                        if (_senhaErradaAdm) {
                          setState(() => _senhaErradaAdm = false);
                        }
                      },
                      onSubmitted: _entrar,
                    ),
                  ],

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _entrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0043AC),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SenhaField extends StatelessWidget {
  const _SenhaField({
    required this.controller,
    required this.visivel,
    required this.erro,
    required this.onToggleVisivel,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool visivel;
  final String? erro;
  final VoidCallback onToggleVisivel;
  final VoidCallback onChanged;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !visivel,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Senha',
        border: const OutlineInputBorder(),
        errorText: erro,
        suffixIcon: IconButton(
          icon: Icon(visivel ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggleVisivel,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Digite a senha';
        }
        return null;
      },
      onChanged: (_) => onChanged(),
      onFieldSubmitted: (_) => onSubmitted(),
    );
  }
}
