import 'package:analyzer/dart/constant/value.dart';

T? dartConstObjectField<T>(DartObject? dartObject, String fieldName) {
  if (dartObject == null) {
    return null;
  }
  return dartConstObjectValue(dartObject.getField(fieldName));
}

dynamic dartConstObjectValue(DartObject? dartObject) {
  if (dartObject == null) {
    return null;
  }
  var fieldType = dartObject.type;
  if (fieldType == null || fieldType.isDartCoreNull) {
    return null;
  } else if (fieldType.isDartCoreString) {
    return dartObject.toStringValue();
  } else if (fieldType.isDartCoreBool) {
    return dartObject.toBoolValue();
  } else if (fieldType.isDartCoreInt) {
    return dartObject.toIntValue();
  } else if (fieldType.isDartCoreDouble) {
    return dartObject.toDoubleValue();
  } else if (fieldType.isDartCoreDouble) {
    return dartObject.toDoubleValue();
  } else if (fieldType.isDartCoreList) {
    var internal = dartObject.toListValue();
    if (internal == null) {
      return null;
    }
    return [for (DartObject content in internal) dartConstObjectValue(content)];
  } else if (fieldType.isDartCoreMap) {
    var internal = dartObject.toMapValue();
    if (internal == null) {
      return null;
    }
    return {
      for (var content in internal.keys)
        dartConstObjectValue(content): dartConstObjectValue(internal[content])
    };
  } else if (fieldType.isDartCoreSet) {
    var internal = dartObject.toSetValue();
    if (internal == null) {
      return null;
    }
    return {for (DartObject content in internal) dartConstObjectValue(content)};
  } else {
    // Todo
    throw UnsupportedError(
        'Unsupported type ${fieldType.getDisplayString(withNullability: true)}');
  }
}
