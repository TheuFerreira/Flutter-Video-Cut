import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/screens/join_cuts/controllers/join_cuts_controller.dart';
import 'package:flutter_video_cut/app/shared/components/clip_widget.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/dialog_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JoinCutsPage extends StatefulWidget {
  final List<CutModel> cuts;
  const JoinCutsPage(
    this.cuts, {
    Key? key,
  }) : super(key: key);

  @override
  _JoinCutsPageState createState() => _JoinCutsPageState();
}

class _JoinCutsPageState extends State<JoinCutsPage> {
  late JoinCutsController _controller;

  @override
  void initState() {
    super.initState();

    _controller = JoinCutsController(widget.cuts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FaIcon(
              FontAwesomeIcons.objectGroup,
              color: Colors.amber,
            ),
            SizedBox(width: 8.0),
            Text(
              'Juntar Clips',
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
              'Para juntar clipes, basta selecionar pelo menos 2 clips e clicar em CONFIRMAR',
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
                  onPressed: hasSelected ? () => _controller.joinClips(context) : null,
                  child: const Text('Confirmar'),
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
