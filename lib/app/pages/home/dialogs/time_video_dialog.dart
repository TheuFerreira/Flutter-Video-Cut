import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_cut/domain/utils/time.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TimeVideoDialog extends StatefulWidget {
  final int maxSecondsOfVideo;
  const TimeVideoDialog({
    Key? key,
    required this.maxSecondsOfVideo,
  }) : super(key: key);

  @override
  State<TimeVideoDialog> createState() => _TimeVideoDialogState();
}

class _TimeVideoDialogState extends State<TimeVideoDialog> {
  final formKey = GlobalKey<FormState>();
  TextEditingController secondsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    secondsController =
        TextEditingController(text: widget.maxSecondsOfVideo >= 29 ? '29' : '${widget.maxSecondsOfVideo}');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 8.0),
                const FaIcon(
                  FontAwesomeIcons.info,
                  size: 56,
                  color: Colors.white,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Tempo por clipe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Insira o tempo por clipe em segundos.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 150,
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: const TextInputType.numberWithOptions(),
                      textAlign: TextAlign.center,
                      controller: secondsController,
                      validator: validateSeconds,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(hintText: '29'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^([1-9]|[1-9][0-9]|99)$'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _onCancel,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: Colors.amber,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(16.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: _onConfirm,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Confirmar',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? validateSeconds(String? value) {
    if (value!.isEmpty) {
      return 'Insira um valor.';
    }

    final valueInt = int.parse(value);
    if (valueInt < minSecondsPerVideo) {
      return 'Mínimo de $minSecondsPerVideo segundos.';
    } else if (valueInt > widget.maxSecondsOfVideo) {
      return 'Máximo de ${widget.maxSecondsOfVideo} segundos';
    }

    return null;
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    if (formKey.currentState!.validate() == false) {
      return;
    }

    final seconds = int.parse(secondsController.text);
    Navigator.of(context).pop(seconds);
  }
}
