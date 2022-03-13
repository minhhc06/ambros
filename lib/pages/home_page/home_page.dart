import 'dart:io';

import 'package:ambros_app/pages/home_page/components/home_components.dart';
import 'package:ambros_app/utils/base_components.dart';
import 'package:ambros_app/utils/size_util.dart';
import 'package:ambros_app/utils/words_util.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with BaseComponents {
  late TextEditingController inputController;
  final _formKey = GlobalKey<FormState>();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    inputController = TextEditingController();
    HomeComponent().readCounter().then((String value) {
      setState(() {
        inputController.text = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${WordsUtil.confidence}: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(SizeUtil.padding16),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(WordsUtil.androidChallenge),
                  const SizedBox(height: SizeUtil.padding8,),
                  Card(
                      margin: EdgeInsets.zero,
                      color: Colors.grey,
                      child: TextFormField(
                        controller: inputController,
                        maxLines: 8,
                        decoration: const InputDecoration.collapsed(hintText: WordsUtil.inputText),
                        validator: (value) {
                          if (value?.trim() == null || value!.isEmpty) {

                            return WordsUtil.validateText;
                          }
                          return null;
                        },
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: SizeUtil.padding8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                            child: buttonUtil(title: WordsUtil.read, background: Colors.white, titleColor: Colors.red,
                            handleOnPress: (){
                              HomeComponent().readCounter().then((String value) {
                                setState(() {
                                  inputController.text = value;
                                });
                              });
                            })),
                        const SizedBox(width: 20,),
                        Expanded(
                          flex: 1,
                            child: buttonUtil(title: WordsUtil.write, handleOnPress: (){
                            if (_formKey.currentState!.validate()) {
                              HomeComponent().writeValue(inputController.text);
                            }
                            }))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            inputController.text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}