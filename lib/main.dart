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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          '✈️ FlutterTrips',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
                'Uma ilha vulcânica no Mar Egeu, conhecida por suas vistas deslumbrantes, casinhas brancas com cúpulas azuis e pores do sol inesquecíveis. Um destino romântico imperdível.',
            imageUrl:
                'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=800&q=80',
          ),
          TravelCard(
            cityName: 'Kyoto',
            countryName: 'Japão',
            rating: 4.9,
            reviewCount: 5120,
            description:
                'Antiga capital imperial do Japão, repleta de templos budistas, jardins zen, geishas tradicionais e a magia das cerejeiras em flor durante a primavera.',
            imageUrl:
                'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?w=800&q=80',
          ),
          TravelCard(
            cityName: 'Machu Picchu',
            countryName: 'Peru',
            rating: 4.7,
            reviewCount: 3890,
            description:
                'A cidade perdida dos Incas, situada no alto dos Andes. Uma das maravilhas do mundo moderno, cercada por montanhas envoltas em névoa e história milenar.',
            imageUrl:
                'https://images.unsplash.com/photo-1587595431973-160d0d94add1?w=800&q=80',
          ),
        ],
      ),
    );
  }
}

// =============================================================
//  TRAVEL CARD — Widget Principal
// =============================================================
class TravelCard extends StatefulWidget {
  final String cityName;
  final String countryName;
  final double rating;
  final int reviewCount;
  final String description;
  final String imageUrl;

  const TravelCard({
    super.key,
    required this.cityName,
    required this.countryName,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageUrl,
  });

  @override
  State<TravelCard> createState() => _TravelCardState();
}

class _TravelCardState extends State<TravelCard> {
  bool _isFavorited = false;

  // ----------------------------------------------------------
  //  PASSO 4: LayoutBuilder — cérebro da responsividade
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          // TELA ESTREITA: layout vertical (mobile)
          return _buildMobileLayout();
        } else {
          // TELA LARGA: layout horizontal (tablet / web)
          return _buildTabletLayout();
        }
      },
    );
  }

  // ----------------------------------------------------------
  //  PASSO 2 + 3: Container com sombra + Stack em camadas
  // ----------------------------------------------------------
  Widget _buildMobileLayout() {
    return Container(
      height: 240,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      // PASSO 2: BoxDecoration com BorderRadius e BoxShadow
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4), // sombra vinda de cima
          ),
        ],
      ),
      // PASSO 3: ClipRRect garante que a imagem respeite o arredondamento
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // CAMADA 1: Imagem de fundo
            Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),

            // CAMADA 2: Gradiente + textos na parte inferior
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
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Nome da cidade
                    Text(
                      widget.cityName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Nome do país
                    Text(
                      widget.countryName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Row com avaliação em estrelas
                    _buildRatingRow(starColor: Colors.amber),
                  ],
                ),
              ),
            ),

            // CAMADA 3: Botão de favorito no topo direito
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
    );
  }

  // ----------------------------------------------------------
  //  PASSO 4: Layout Horizontal (Tablet / Web)
  // ----------------------------------------------------------
  Widget _buildTabletLayout() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                  // Botão de favorito sobre a imagem
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

            // DIREITA: Informações de texto (flex 3)
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Nome da cidade
                    Text(
                      widget.cityName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // País com ícone
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 2),
                        Text(
                          widget.countryName,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Avaliação
                    _buildRatingRow(starColor: Colors.amber, darkText: true),
                    const SizedBox(height: 10),
                    // DESAFIO EXTRA: Descrição com Expanded + ellipsis
                    Expanded(
                      child: Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis, // trunca com "..."
                      ),
                    ),
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

  /// Row com estrelas e contagem de avaliações
  Widget _buildRatingRow({required Color starColor, bool darkText = false}) {
    final textColor = darkText ? Colors.black87 : Colors.white;
    final subColor = darkText ? Colors.grey : Colors.white70;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Estrelas dinâmicas baseadas na nota
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
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(${widget.reviewCount})',
          style: TextStyle(color: subColor, fontSize: 12),
        ),
      ],
    );
  }

  /// Botão de favorito com toggle de estado
  Widget _buildFavoriteButton({
    required Color iconColor,
    required Color bgColor,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _isFavorited = !_isFavorited),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isFavorited ? Icons.favorite : Icons.favorite_border,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }
}