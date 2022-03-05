import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/screens/share/controllers/share_controller.dart';
import 'package:flutter_video_cut/app/shared/components/clip_widget.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/dialog_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SharePage extends StatefulWidget {
  final List<CutModel> cuts;
  const SharePage(
    this.cuts, {
    Key? key,
  }) : super(key: key);

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  late ShareController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ShareController(widget.cuts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.share,
              color: Colors.amber,
            ),
            SizedBox(width: 8.0),
            Text(
              'Compartilhar Clips',
              style: TextStyle(
                fontSize: 22,
                color: Colors.amber,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.info),
            onPressed: () => DialogService.showInfoDialog(
              context,
              'Para compartilhar os clipes, basta selecionar pelo menos 1 clip e clicar em COMPARTILHAR',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _controller.cuts.length,
              itemBuilder: (ctx, index) => Observer(
                builder: (context) {
                  final cut = _controller.cuts[index];
                  final isSelected = _controller.selectedCuts.contains(cut);
                  return ClipWidget(
                    index,
                    cut,
                    isSelected: isSelected,
                    onTap: _controller.clickCut,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Observer(
              builder: (context) {
                final hasSelected = _controller.hasSelected;
                return TextButton(
                  onPressed: hasSelected ? () => _controller.share(context) : null,
                  child: const Text('Compartilhar'),
                  style: TextButton.styleFrom(
                    elevation: hasSelected ? 4 : 0,
                    backgroundColor: hasSelected ? const Color.fromARGB(255, 50, 50, 50) : null,
                    primary: Colors.white,
                    fixedSize: Size(MediaQuery.of(context).size.width, 45),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
