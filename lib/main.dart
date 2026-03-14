import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterTripsApp());
}

class FlutterTripsApp extends StatelessWidget {
  const FlutterTripsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterTrips',
      debugShowCheckedModeBanner: false,

      // ── Passo 2: ThemeData com a cor oficial da marca ──────────────
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),

      // ── Desafio Extra: Dark Mode dinâmico do sistema ───────────────
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system, // respeita a preferência do SO

      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 1,
        title: Text(
          '✈️ FlutterTrips',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: const [
          TravelCard(
            cityName: 'Santorini',
            countryName: 'Grécia',
            rating: 4.8,
            reviewCount: 2340,
            description:
                'Uma ilha vulcânica no Mar Egeu, conhecida por suas vistas deslumbrantes, '
                'casinhas brancas com cúpulas azuis e pores do sol inesquecíveis. '
                'Um destino romântico imperdível.',
            // ── Passo 1: usar imagem local ──────────────────────────
            imageAsset: 'assets/images/santorini.jpg',
          ),
          TravelCard(
            cityName: 'Kyoto',
            countryName: 'Japão',
            rating: 4.9,
            reviewCount: 5120,
            description:
                'Antiga capital imperial do Japão, repleta de templos budistas, jardins zen, '
                'geishas tradicionais e a magia das cerejeiras em flor durante a primavera.',
            imageAsset: 'assets/images/kyoto.jpg',
          ),
          TravelCard(
            cityName: 'Machu Picchu',
            countryName: 'Peru',
            rating: 4.7,
            reviewCount: 3890,
            description:
                'A cidade perdida dos Incas, situada no alto dos Andes. Uma das maravilhas '
                'do mundo moderno, cercada por montanhas envoltas em névoa e história milenar.',
            imageAsset: 'assets/images/machu_picchu.jpg',
          ),
        ],
      ),
    );
  }
}

// =============================================================
//  TRAVEL CARD — Widget Principal
// =============================================================

// ── Passo 3: já convertido para StatefulWidget ────────────────
class TravelCard extends StatefulWidget {
  final String cityName;
  final String countryName;
  final double rating;
  final int reviewCount;
  final String description;
  final String imageAsset; // ← Passo 1: caminho do asset local

  const TravelCard({
    super.key,
    required this.cityName,
    required this.countryName,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageAsset,
  });

  @override
  State<TravelCard> createState() => _TravelCardState();
}

class _TravelCardState extends State<TravelCard> {
  // ── Passo 4: estado do favorito ───────────────────────────────
  bool _isFavorited = false;

  // ── Passo 5: estado do "Já Visitei" ──────────────────────────
  bool _jaVisitou = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return _buildMobileLayout();
        } else {
          return _buildTabletLayout();
        }
      },
    );
  }

  // ----------------------------------------------------------
  //  Layout Mobile — Stack vertical
  // ----------------------------------------------------------
  Widget _buildMobileLayout() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Imagem + overlay ──────────────────────────────
            SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ── Passo 1: Image.asset ──────────────────
                  Image.asset(
                    widget.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                      ),
                    ),
                  ),

                  // Gradiente + textos
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black87, Colors.transparent],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ── Passo 2: texto com Theme.of(context) ──
                          Text(
                            widget.cityName,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.countryName,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          _buildRatingRow(starColor: Colors.amber),
                        ],
                      ),
                    ),
                  ),

                  // ── Passo 4: botão favorito ───────────────
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _buildFavoriteButton(
                      iconColor: _isFavorited ? Colors.red : Colors.white,
                      bgColor: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),

            // ── Passo 5: Switch "Já visitei" no mobile ────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: _buildVisitedRow(),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  //  Layout Tablet — Row horizontal
  // ----------------------------------------------------------
  Widget _buildTabletLayout() {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // ESQUERDA: Imagem (flex 2)
            Expanded(
              flex: 2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ── Passo 1: Image.asset ──────────────────
                  Image.asset(
                    widget.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                      ),
                    ),
                  ),
                  // ── Passo 4: botão favorito ───────────────
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _buildFavoriteButton(
                      iconColor: _isFavorited ? Colors.red : Colors.white,
                      bgColor: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),

            // DIREITA: Textos (flex 3)
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Passo 2: texto com Theme.of(context) ──
                    Text(
                      widget.cityName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14,
                            color: Theme.of(context).colorScheme.secondary),
                        const SizedBox(width: 2),
                        Text(
                          widget.countryName,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildRatingRow(starColor: Colors.amber, darkText: true),
                    const SizedBox(height: 8),
                    // Descrição com ellipsis
                    Expanded(
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // ── Passo 5: Switch "Já visitei" ─────────
                    _buildVisitedRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  //  Widgets auxiliares reutilizáveis
  // ----------------------------------------------------------

  /// Passo 5: Row com Switch.adaptive para "Já visitei"
  Widget _buildVisitedRow() {
    return Row(
      children: [
        Text(
          'Já visitei este destino',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Switch.adaptive(
          value: _jaVisitou,
          activeColor: Theme.of(context).colorScheme.primary,
          // ── Passo 5: setState para atualizar o estado ─────
          onChanged: (bool novoValor) {
            setState(() {
              _jaVisitou = novoValor;
            });
          },
        ),
      ],
    );
  }

  /// Row com estrelas e contagem de avaliações
  Widget _buildRatingRow({required Color starColor, bool darkText = false}) {
    final textColor = darkText
        ? Theme.of(context).colorScheme.onSurface
        : Colors.white;
    final subColor = darkText
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : Colors.white70;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          final full = i < widget.rating.floor();
          final half = !full && i < widget.rating;
          return Icon(
            full
                ? Icons.star
                : half
                    ? Icons.star_half
                    : Icons.star_border,
            color: starColor,
            size: 16,
          );
        }),
        const SizedBox(width: 4),
        Text(
          widget.rating.toStringAsFixed(1),
          style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 4),
        Text(
          '(${widget.reviewCount})',
          style: TextStyle(color: subColor, fontSize: 12),
        ),
      ],
    );
  }

  /// Passo 4: Botão de favorito com toggle de estado
  Widget _buildFavoriteButton({
    required Color iconColor,
    required Color bgColor,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _isFavorited = !_isFavorited),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(
          _isFavorited ? Icons.favorite : Icons.favorite_border,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }
}