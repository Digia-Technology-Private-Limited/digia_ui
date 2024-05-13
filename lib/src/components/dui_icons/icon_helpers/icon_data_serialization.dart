import 'package:flutter/material.dart';
import '../packs/font_awesome_icons.dart' as font_awesome;
import '../packs/cupertino_icons.dart' as cupertino;
import '../packs/line_icons.dart' as line_awesome;
import '../packs/material_icons.dart' as material;
import 'icon_pack.dart';

Map<String, dynamic>? serializeIcon(IconData icon, {IconPack? iconPack}) {
  if (iconPack == null) {
    if (icon.fontFamily == 'MaterialIcons') {
      iconPack = IconPack.material;
    } else if (icon.fontFamily == 'CupertinoIcons') {
      iconPack = IconPack.cupertino;
    } else if (icon.fontPackage == 'font_awesome_flutter') {
      iconPack = IconPack.fontAwesomeIcons;
    } else if (icon.fontFamily == 'LineAwesomeIcons') {
      iconPack = IconPack.lineAwesomeIcons;
    } else {
      iconPack = IconPack.custom;
    }
  }
  switch (iconPack) {
    case IconPack.material:
      return {
        'pack': 'material',
        'key': _getIconKey(material.icons, icon),
      };
    case IconPack.cupertino:
      return {
        'pack': 'cupertino',
        'key': _getIconKey(cupertino.cupertinoIcons, icon),
      };
    case IconPack.fontAwesomeIcons:
      return {
        'pack': 'fontAwesomeIcons',
        'key': _getIconKey(font_awesome.fontAwesomeIcons, icon),
      };
    case IconPack.lineAwesomeIcons:
      return {
        'pack': 'lineAwesomeIcons',
        'key': _getIconKey(line_awesome.lineAwesomeIcons, icon),
      };
    case IconPack.custom:
      return {
        'pack': 'custom',
        'iconData': {
          'codePoint': icon.codePoint,
          'fontFamily': icon.fontFamily,
          'fontPackage': icon.fontPackage,
          'matchTextDirection': icon.matchTextDirection,
        }
      };
    default:
      return null;
  }
}

IconData? deserializeIcon(Map<String, dynamic> iconMap) {
  try {
    final pack = iconMap['pack'];
    final iconKey = iconMap['key'];
    switch (pack) {
      case 'material':
        return material.icons[iconKey];
      case 'cupertino':
        return cupertino.cupertinoIcons[iconKey];
      case 'fontAwesomeIcons':
        return font_awesome.fontAwesomeIcons[iconKey];
      case 'lineAwesomeIcons':
        return line_awesome.lineAwesomeIcons[iconKey];
      case 'custom':
        final iconData = iconMap['iconData'];
        return IconData(
          iconData['codePoint'],
          fontFamily: iconData['fontFamily'],
          fontPackage: iconData['fontPackage'],
          matchTextDirection: iconData['matchTextDirection'],
        );
      default:
        return null;
    }
  } catch (e) {
    return null;
  }
}

String _getIconKey(Map<String, IconData> icons, IconData icon) =>
    icons.entries.firstWhere((iconEntry) => iconEntry.value == icon).key;

IconData? getIconData({required Map<String, dynamic> icondataMap}) {
  // print('icondata: $pack $key');

  IconData? data = deserializeIcon(icondataMap);
  if (data == null) {
    return null;
  }

  if (icondataMap['pack'] == 'lineAwesomeIcons') {
    IconData iconData = IconData(data.codePoint, fontFamily: data.fontFamily);
    data = iconData;
  }

  return data;
}
