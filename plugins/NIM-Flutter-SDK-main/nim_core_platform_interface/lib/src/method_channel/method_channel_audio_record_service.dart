// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/platform_interface/audio/platform_interface_audio_record_service.dart';
import 'package:nim_core_platform_interface/src/platform_interface/audio/record_info.dart';

class MethodChannelAudioService extends AudioRecordServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    Map<String, dynamic> paramMap = Map<String, dynamic>.from(arguments);
    switch (method) {
      case 'onRecordStateChange':
        _onRecordStateChange(paramMap);
        break;
      default:
        break;
    }
    return Future.value(null);
  }

  _onRecordStateChange(Map<String, dynamic> param) {
    AudioRecordServicePlatform.instance.onAudioRecordStatus
        .add(RecordInfo.fromJson(param));
  }

  @override
  Future<NIMResult<bool>> startAudioRecord(
      Map<String, dynamic>? arguments) async {
    Map<String, dynamic> replyMap =
        await invokeMethod('startRecord', arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<bool>> stopAudioRecord() async {
    Map<String, dynamic> replyMap = await invokeMethod('stopRecord');
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<bool>> cancelAudioRecord() async {
    Map<String, dynamic> replyMap = await invokeMethod('cancelRecord');
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<bool>> isAudioRecording() async {
    Map<String, dynamic> replyMap = await invokeMethod('isAudioRecording');
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<int>> getAmplitude() async {
    Map<String, dynamic> replyMap = await invokeMethod('getAmplitude');
    return NIMResult.fromMap(replyMap);
  }

  @override
  String get serviceName => 'AudioRecordService';
}
