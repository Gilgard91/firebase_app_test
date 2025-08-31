import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget {
  final int page;

  const DemoPage({super.key, required this.page});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {

  List<Map<String, String>> pageContents =
    [
      {
        'title': 'Capitolo 1: L\'Inizio',
        'content': 'Elmer Elevator era un bambino normale che viveva con sua madre...',
        'description': 'La storia inizia con Elmer e sua madre che gestiscono un negozio di caramelle.',
      },
      {
        'title': 'Capitolo 2: Il Trasferimento',
        'content': 'Dopo aver perso il negozio, Elmer e sua madre si trasferirono in una grande città...',
        'description': 'I protagonisti affrontano le difficoltà del trasferimento.',
      },
      {
        'title': 'Capitolo 3: Il Gatto Parlante',
        'content': 'Al porto, Elmer incontrò un gatto molto speciale che gli parlò di un\'isola misteriosa...',
        'description': 'L\'incontro che cambierà tutto per Elmer.',
      },
      {
        'title': 'Capitolo 4: L\'Isola Selvaggia',
        'content': 'Sull\'Isola Selvaggia viveva un drago prigioniero di un gorilla chiamato Saiwa...',
        'description': 'La scoperta dell\'isola e dei suoi abitanti.',
      },
      {
        'title': 'Capitolo 5: Il Drago Boris',
        'content': 'Boris era un drago buffo e simpatico, ma aveva un\'ala rotta...',
        'description': 'L\'incontro con il drago protagonista della storia.',
      },
      {
        'title': 'Capitolo 6: La Liberazione',
        'content': 'Elmer riuscì a liberare Boris dalle catene del gorilla Saiwa...',
        'description': 'Il momento culminante della liberazione.',
      },
      {
        'title': 'Capitolo 7: La Ricerca',
        'content': 'Insieme, Elmer e Boris partirono alla ricerca della tartaruga Aratuah...',
        'description': 'L\'inizio dell\'avventura tra i due protagonisti.',
      },
      {
        'title': 'Capitolo 8: La Saggezza',
        'content': 'Aratuah possedeva la saggezza antica necessaria per salvare l\'isola...',
        'description': 'L\'incontro con il saggio dell\'isola.',
      },
      {
        'title': 'Capitolo 9: Il Potere',
        'content': 'Boris doveva imparare a usare i suoi poteri per diventare un "After Dragon"...',
        'description': 'La trasformazione e crescita del drago.',
      },
      {
        'title': 'Capitolo 10: Il Finale',
        'content': 'Con l\'aiuto di Elmer, Boris riuscì finalmente a volare e salvare l\'isola...',
        'description': 'La conclusione epica dell\'avventura.',
      },
    ];


  @override
  Widget build(BuildContext context) {
    final content = widget.page < pageContents.length
        ? pageContents[widget.page]
        : pageContents.last;

    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                content['title']!,
                style: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Pagina ${widget.page + 1} di 10",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content['content']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Droid Sans',
                            height: 1.5,
                          ),
                        ),
                        // const SizedBox(height: 16),
                        // Container(
                        //   padding: const EdgeInsets.all(12),
                        //   decoration: BoxDecoration(
                        //     color: Colors.black.withOpacity(0.1),
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: Text(
                        //     content['description']!,
                        //     style: const TextStyle(
                        //       fontSize: 14,
                        //       fontStyle: FontStyle.italic,
                        //       color: Colors.black87,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),


                ],
              ),
              const Spacer(),
              // Indicatore di progresso
              _buildProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPageColor() {
    final colors = [
      Colors.red.shade50,
      Colors.blue.shade50,
      Colors.green.shade50,
      Colors.orange.shade50,
      Colors.purple.shade50,
      Colors.teal.shade50,
      Colors.indigo.shade50,
      Colors.pink.shade50,
      Colors.amber.shade50,
      Colors.cyan.shade50,
    ];
    return colors[widget.page % colors.length];
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pagina ${widget.page + 1}'),
            Text('${((widget.page + 1) / 10 * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (widget.page + 1) / 10,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
        ),
      ],
    );
  }
}