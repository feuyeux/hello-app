import { BlurView } from 'expo-blur';
import { StyleSheet } from 'react-native';

import { useBottomTabOverflow } from '@/components/ui/TabBarBackground.web';

export default function TabBarBackground() {
  const { height = 0, overflow = 'hidden' } = useBottomTabOverflow();
  return (
    <BlurView
      style={[StyleSheet.absoluteFill, { overflow }]}
      intensity={95}
      tint="extraLight"
      experimentalBlurMethod="dimezisBlurView"
    />
  );
}