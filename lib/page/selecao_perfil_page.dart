import 'package:flutter/material.dart';

import 'pedidos/home_page.dart';
import 'corte/corte_industrial_home_page.dart';

enum TipoUsuario { operadores, corte }

class SelecaoPerfilPage extends StatefulWidget {
  const SelecaoPerfilPage({super.key});

  @override
  State<SelecaoPerfilPage> createState() => _SelecaoPerfilPageState();
}

class _SelecaoPerfilPageState extends State<SelecaoPerfilPage> {
  // Senha fixa local, só pra não deixar qualquer um entrar sem querer
  // na tela de corte. Não é uma senha "de verdade" - é o mesmo nível
  // de segurança que a API key embutida no app.
  static const String _senhaCorte = '9616';

  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();

  TipoUsuario? _tipoSelecionado;
  bool _senhaVisivel = false;
  bool _senhaErrada = false;

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  void _entrar() {
    if (!_formKey.currentState!.validate()) return;

    if (_tipoSelecionado == TipoUsuario.operadores) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      return;
    }

    // Tipo == corte: confere a senha antes de deixar entrar
    if (_senhaController.text == _senhaCorte) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CorteIndustrialHomePage()),
      );
    } else {
      setState(() => _senhaErrada = true);
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
                    ],
                    validator: (value) =>
                        value == null ? 'Selecione um tipo de usuário' : null,
                    onChanged: (value) {
                      setState(() {
                        _tipoSelecionado = value;
                        _senhaErrada = false;
                        _senhaController.clear();
                      });
                    },
                  ),

                  // Campo de senha só aparece se escolher "Corte Industrial"
                  if (_tipoSelecionado == TipoUsuario.corte) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: !_senhaVisivel,
                       keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: const OutlineInputBorder(),
                        errorText: _senhaErrada ? 'Senha incorreta' : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _senhaVisivel
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => _senhaVisivel = !_senhaVisivel),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite a senha';
                        }
                        return null;
                      },
                      onChanged: (_) {
                        if (_senhaErrada) setState(() => _senhaErrada = false);
                      },
                      onFieldSubmitted: (_) => _entrar(),
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