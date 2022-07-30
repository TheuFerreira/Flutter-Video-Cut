import 'package:flutter_video_cut/domain/entities/text_info.dart';

const cutVideoTexts = [
  TextInfo(text: 'Aguarde um pouco...'),
  TextInfo(
    text: 'Estamos cortando seu vídeo em pedacinhos...',
    duration: 3500,
  ),
  TextInfo(
    text: 'Estamos gerando as Thumbnails dos seus clips...',
    duration: 4000,
  ),
  TextInfo(text: 'Aguarde mais um pouco...'),
];

const joinClipsText = [
  TextInfo(text: 'Aguarde um pouco...'),
  TextInfo(
    text: 'Estamos unindo os pedacinhos do seus clips...',
    duration: 3500,
  ),
  TextInfo(
    text: 'Estamos gerando a Thumbnail do seu clip...',
    duration: 4000,
  ),
  TextInfo(text: 'Aguarde mais um pouco...'),
];
