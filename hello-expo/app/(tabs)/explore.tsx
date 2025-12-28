import Ionicons from '@expo/vector-icons/Ionicons';
import { StyleSheet, Image, Platform } from 'react-native';

import { Collapsible } from '@/components/Collapsible';
import { ExternalLink } from '@/components/ExternalLink';
import ParallaxScrollView from '@/components/ParallaxScrollView';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';

export default function TabTwoScreen() {
  return (
    <ParallaxScrollView
      headerBackgroundColor={{ light: '#D0D0D0', dark: '#353636' }}
      headerImage={<Ionicons size={310} name="code-slash" style={styles.headerImage} />}>
      <ThemedView style={styles.titleContainer}>
        <ThemedText type="title">探索 Expo</ThemedText>
      </ThemedView>
      <ThemedText>这个应用包含了一个示例代码来帮助你开始使用 Expo。</ThemedText>
      <Collapsible title="文件路由">
        <ThemedText>
          这个应用有两个屏幕：{' '}
          <ThemedText type="defaultSemiBold">app/(tabs)/index.tsx</ThemedText> 和{' '}
          <ThemedText type="defaultSemiBold">app/(tabs)/explore.tsx</ThemedText>
        </ThemedText>
        <ThemedText>
          布局文件在 <ThemedText type="defaultSemiBold">app/(tabs)/_layout.tsx</ThemedText>{' '}
          中配置了标签导航器。
        </ThemedText>
        <ExternalLink href="https://docs.expo.dev/router/introduction">
          <ThemedText type="link">了解更多</ThemedText>
        </ExternalLink>
      </Collapsible>
      <Collapsible title="Android、iOS 和 Web">
        <ThemedText>
          你可以在 Android、iOS 和 Web 上打开这个应用。要在 Web 上打开，
          按 <ThemedText type="defaultSemiBold">w</ThemedText> 在终端中运行{' '}
          <ThemedText type="defaultSemiBold">npx expo start</ThemedText>。
        </ThemedText>
      </Collapsible>
      <Collapsible title="图片">
        <ThemedText>
          对于静态图片，你可以使用 <ThemedText type="defaultSemiBold">@</ThemedText> 符号来引用{' '}
          <ThemedText type="defaultSemiBold">assets</ThemedText> 目录中的文件。
        </ThemedText>
        <Image source={require('@/assets/images/react-logo.png')} style={{ alignSelf: 'center' }} />
        <ExternalLink href="https://reactnative.dev/docs/images">
          <ThemedText type="link">了解更多</ThemedText>
        </ExternalLink>
      </Collapsible>
      <Collapsible title="自定义字体">
        <ThemedText>
          在 <ThemedText type="defaultSemiBold">app/_layout.tsx</ThemedText> 中打开{' '}
          <ThemedText style={{ fontFamily: 'SpaceMono' }}>
            app/_layout.tsx
          </ThemedText>{' '}
          来查看如何加载{' '}
          <ThemedText style={{ fontFamily: 'SpaceMono' }}>自定义字体，比如这个。</ThemedText>
        </ThemedText>
        <ExternalLink href="https://docs.expo.dev/versions/latest/sdk/font">
          <ThemedText type="link">了解更多</ThemedText>
        </ExternalLink>
      </Collapsible>
      <Collapsible title="浅色和深色模式组件">
        <ThemedText>
          这个模板有浅色和深色模式支持。<ThemedText type="defaultSemiBold">useColorScheme()</ThemedText>{' '}
          hook 让你检查用户当前的颜色方案，你可以使用它来调整你的应用的外观。
        </ThemedText>
        <ExternalLink href="https://docs.expo.dev/develop/user-interface/color-themes/">
          <ThemedText type="link">了解更多</ThemedText>
        </ExternalLink>
      </Collapsible>
      <Collapsible title="动画">
        <ThemedText>
          这个模板包含了一个使用 Reanimated 库制作的动画示例。
          波浪手势 emoji 在主页上有一个弹跳动画。
        </ThemedText>
        <ExternalLink href="https://docs.expo.dev/develop/user-interface/animation/">
          <ThemedText type="link">了解更多</ThemedText>
        </ExternalLink>
      </Collapsible>
    </ParallaxScrollView>
  );
}

const styles = StyleSheet.create({
  headerImage: {
    color: '#808080',
    bottom: -90,
    left: -35,
    position: 'absolute',
  },
  titleContainer: {
    flexDirection: 'row',
    gap: 8,
  },
});