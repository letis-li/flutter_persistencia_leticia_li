import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaginaLeitura();
  }
}

class PaginaLeitura extends StatefulWidget {
  const PaginaLeitura({super.key});

  @override
  State<PaginaLeitura> createState() => _PaginaLeituraState();
}

class _PaginaLeituraState extends State<PaginaLeitura> {
  final _prefs = SharedPreferencesAsync();

  static const _chaveTema = 'leitura.temaEscuro';
  static const _chaveFonte = 'leitura.tamanhoFonte';

  bool _temaEscuro = false;
  double _tamanhoFonte = 18;

  String? _erro;
  bool _carregando = true;
  bool _gravando = false;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final tema = await _prefs.getBool(_chaveTema) ?? false;
      final fonte = await _prefs.getDouble(_chaveFonte) ?? 18.0;

      if (!mounted) return;

      setState(() {
        _temaEscuro = tema;
        _tamanhoFonte = fonte;
      });
    } catch (e) {
      debugPrint('Erro ao carregar preferências: $e');

      if (mounted) {
        setState(() {
          _erro = 'Falha ao carregar as preferências.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  void _avisar(BuildContext contexto, String mensagem) {
    ScaffoldMessenger.of(contexto).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> _salvar(BuildContext contexto) async {
    if (_gravando) return;

    setState(() => _gravando = true);

    try {
      await _prefs.setBool(_chaveTema, _temaEscuro);
      await _prefs.setDouble(_chaveFonte, _tamanhoFonte);

      if (!mounted) return;

      _avisar(contexto, 'Preferências salvas.');
    } catch (e) {
      debugPrint('Erro ao salvar preferências: $e');

      if (mounted) {
        _avisar(contexto, 'Falha ao salvar. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() => _gravando = false);
      }
    }
  }

  Future<void> _restaurar(BuildContext contexto) async {
    if (_gravando) return;

    setState(() => _gravando = true);

    try {
      await _prefs.remove(_chaveTema);
      await _prefs.remove(_chaveFonte);

      if (!mounted) return;

      setState(() {
        _temaEscuro = false;
        _tamanhoFonte = 18;
      });

      _avisar(contexto, 'Padrão restaurado.');
    } catch (e) {
      debugPrint('Erro ao restaurar padrão: $e');

      if (mounted) {
        _avisar(contexto, 'Falha ao restaurar o padrão.');
      }
    } finally {
      if (mounted) {
        setState(() => _gravando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _temaEscuro ? Brightness.dark : Brightness.light,
      ),
      home: Builder(
        builder: (contexto) {
          Widget conteudo;

          if (_carregando) {
            conteudo = const Center(
              child: CircularProgressIndicator(),
            );
          } else if (_erro != null) {
            conteudo = Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_erro!),
                  TextButton(
                    onPressed: _carregar,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          } else {
            conteudo = ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    const Text('Tema escuro'),
                    Switch(
                      value: _temaEscuro,
                      onChanged: _gravando
                          ? null
                          : (valor) {
                              setState(() => _temaEscuro = valor);
                            },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Tamanho da fonte: '
                  '${_tamanhoFonte.toStringAsFixed(0)}',
                ),
                Slider(
                  value: _tamanhoFonte,
                  min: 14,
                  max: 28,
                  divisions: 7,
                  label: _tamanhoFonte.toStringAsFixed(0),
                  onChanged: _gravando
                      ? null
                      : (valor) {
                          setState(() => _tamanhoFonte = valor);
                        },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Prévia do texto',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'A leitura permite conhecer novas histórias '
                  'e descobrir diferentes ideias. Ajuste o tema '
                  'e o tamanho da fonte para ler com conforto.',
                  style: TextStyle(fontSize: _tamanhoFonte),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _gravando
                      ? null
                      : () => _salvar(contexto),
                  child: Text(
                    _gravando ? 'Aguarde...' : 'Salvar preferências',
                  ),
                ),
                TextButton(
                  onPressed: _gravando
                      ? null
                      : () => _restaurar(contexto),
                  child: const Text('Restaurar padrão'),
                ),
              ],
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Preferências de leitura'),
            ),
            body: SafeArea(child: conteudo),
          );
        },
      ),
    );
  }
}