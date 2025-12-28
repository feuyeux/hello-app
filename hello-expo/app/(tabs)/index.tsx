import { Image, StyleSheet, Platform } from 'react-native';

import { HelloWave } from '@/components/HelloWave';
import ParallaxScrollView from '@/components/ParallaxScrollView';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';

export default function HomeScreen() {
  return (
    <ParallaxScrollView
      headerBackgroundColor={{ light: '#A1CEDC', dark: '#1D3D47' }}
      headerImage={
        <Image
          source={require('@/assets/images/partial-react-logo.png')}
          style={styles.reactLogo}
        />
      }>
      <ThemedView style={styles.titleContainer}>
        <ThemedText type="title">欢迎使用 Expo!</ThemedText>
        <HelloWave />
      </ThemedView>
      <ThemedView style={styles.stepContainer}>
        <ThemedText type="subtitle">步骤 1: 尝试修改代码</ThemedText>
        <ThemedText>
          编辑 <ThemedText type="defaultSemiBold">app/(tabs)/index.tsx</ThemedText> 来查看实时更新。
          按 <ThemedText type="defaultSemiBold">{Platform.select({ ios: 'cmd + d', android: 'cmd + m' })}</ThemedText> 打开开发者菜单。
        </ThemedText>
      </ThemedView>
      <ThemedView style={styles.stepContainer}>
        <ThemedText type="subtitle">步骤 2: 探索功能</ThemedText>
        <ThemedText>
          点击 Explore 标签页查看 Expo 提供的各种功能示例。
        </ThemedText>
      </ThemedView>
      <ThemedView style={styles.stepContainer}>
        <ThemedText type="subtitle">步骤 3: 获取新的想法</ThemedText>
        <ThemedText>
          当你准备好时，运行{' '}
          <ThemedText type="defaultSemiBold">npm run reset-project</ThemedText> 来获得一个新的开始。
        </ThemedText>
      </ThemedView>
    </ParallaxScrollView>
  );
}

const styles = StyleSheet.create({
  titleContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  stepContainer: {
    gap: 8,
    marginBottom: 8,
  },
  reactLogo: {
    height: 178,
    width: 290,
    bottom: 0,
    left: 0,
    position: 'absolute',
  },
});