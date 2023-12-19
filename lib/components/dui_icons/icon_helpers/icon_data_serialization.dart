import 'package:digia_ui/components/dui_icons/icon_helpers/icon_pack.dart';
import 'package:flutter/material.dart';
import '../Packs/FontAwesome.dart' as fontAwesome;
import '../Packs/Cupertino.dart' as cupertino;
import '../Packs/LineIcons.dart' as lineAwesome;

import '../Packs/Material.dart' as material;

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
        'key': _getIconKey(fontAwesome.fontAwesomeIcons, icon),
      };
    case IconPack.lineAwesomeIcons:
      return {
        'pack': 'lineAwesomeIcons',
        'key': _getIconKey(lineAwesome.lineAwesomeIcons, icon),
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
        return fontAwesome.fontAwesomeIcons[iconKey];
      case 'lineAwesomeIcons':
        return lineAwesome.lineAwesomeIcons[iconKey];
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
