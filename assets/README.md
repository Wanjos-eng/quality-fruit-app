# Assets do Projeto - Ícones e Imagens

## 📁 Estrutura de Pastas

```
assets/
├── icons/
│   ├── app_icon/           # Ícones principais do app
│   │   ├── logo_1024.png   # Logo alta resolução (1024x1024)
│   │   └── logo_512.png    # Logo Play Store (512x512)
│   └── android/            # Recursos específicos Android
│       └── res/
│           ├── mipmap-anydpi-v26/
│           ├── mipmap-hdpi/
│           ├── mipmap-mdpi/
│           ├── mipmap-xhdpi/
│           ├── mipmap-xxhdpi/
│           └── mipmap-xxxhdpi/
└── images/                 # Imagens gerais do app
```

## 🎯 Como Usar

### 1. Ícones no Flutter

```dart
import 'package:flutter/material.dart';
import '../core/constants/app_assets.dart';

// Usar logo em um Image widget
Image.asset(
  AppAssets.logoHigh,  // ou AppAssets.logoPlayStore
  width: 100,
  height: 100,
)

// Usar logo com tamanho dinâmico
Image.asset(
  AppAssets.getLogoPath(highRes: true),
  fit: BoxFit.contain,
)
```

### 2. Configurar Ícone do App Android

Para usar os ícones Android como ícone oficial do app:

1. Copie o conteúdo de `assets/icons/android/res/` para `android/app/src/main/res/`
2. Edite `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:icon="@mipmap/Icone_PuraFruta"
    android:roundIcon="@mipmap/Icone_PuraFruta"
    ...>
```

### 3. Splash Screen com Logo Real

Para usar o logo real na splash screen, substitua no arquivo `animated_logo_splash.dart`:

```dart
// No lugar do CustomPaint, use:
Image.asset(
  AppAssets.logoHigh,
  width: 120,
  height: 120,
)
```

## 📋 Checklist de Configuração

- [x] Assets organizados em pastas apropriadas
- [x] pubspec.yaml atualizado com assets
- [x] Classe AppAssets criada para facilitar uso
- [ ] Ícone do app configurado no Android
- [ ] Splash screen atualizada com logo real (opcional)
- [ ] Ícone do app configurado no iOS (quando necessário)

## 🔧 Próximos Passos

1. **Teste os assets**: Execute `flutter run` para verificar se os assets carregam
2. **Configure ícone do app**: Siga as instruções acima para Android
3. **Atualize splash screen**: Se desejar usar o logo real
4. **iOS**: Configure os ícones para iOS quando necessário
