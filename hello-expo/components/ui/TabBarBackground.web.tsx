import { useBottomTabBarHeight } from '@react-navigation/bottom-tabs';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

export function useBottomTabOverflow() {
  const tabHeight = useBottomTabBarHeight();
  const { bottom } = useSafeAreaInsets();
  return {
    height: tabHeight,
    overflow: 'hidden' as const,
  };
}

export default function TabBarBackground() {
  return null;
}