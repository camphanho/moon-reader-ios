import React from 'react';
import { NavigationContainer, DefaultTheme, DarkTheme } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { StatusBar } from 'expo-status-bar';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { Ionicons } from '@expo/vector-icons';
import { useAppSettingsStore } from './src/store/appSettingsStore';
import { Theme } from './src/utils/constants';

// Screens (sẽ tạo sau)
import LibraryScreen from './src/components/library/BookShelfView';
import ReaderScreen from './src/components/reader/ReadingView';
import SettingsScreen from './src/components/settings/SettingsView';

const Tab = createBottomTabNavigator();

export default function App() {
  const theme = useAppSettingsStore((state) => state.theme);
  const accentColor = useAppSettingsStore((state) => state.accentColor);

  const navigationTheme =
    theme === Theme.NIGHT || theme === Theme.AMOLED
      ? {
          ...DarkTheme,
          colors: {
            ...DarkTheme.colors,
            primary: accentColor,
            background: theme === Theme.AMOLED ? '#000000' : DarkTheme.colors.background,
          },
        }
      : {
          ...DefaultTheme,
          colors: {
            ...DefaultTheme.colors,
            primary: accentColor,
          },
        };

  const tabBarStyle =
    theme === Theme.NIGHT || theme === Theme.AMOLED
      ? {
          backgroundColor: '#111827',
          borderTopColor: '#1F2937',
        }
      : {
          backgroundColor: '#F2F2F7',
          borderTopColor: '#C6C6C8',
        };

  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <SafeAreaProvider>
        <NavigationContainer theme={navigationTheme}>
          <Tab.Navigator
            screenOptions={{
              headerShown: false,
              tabBarActiveTintColor: accentColor,
              tabBarInactiveTintColor: theme === Theme.DAY || theme === Theme.SEPIA ? '#8E8E93' : '#9CA3AF',
              tabBarStyle: { ...tabBarStyle, borderTopWidth: 0.5 },
            }}
          >
            <Tab.Screen
              name="Library"
              component={LibraryScreen}
              options={{
                tabBarLabel: 'Thư viện',
                tabBarIcon: ({ color, size }) => (
                  <Ionicons name="library" size={size} color={color} />
                ),
              }}
            />
            <Tab.Screen
              name="Reader"
              component={ReaderScreen}
              options={{
                tabBarLabel: 'Đọc sách',
                tabBarIcon: ({ color, size }) => (
                  <Ionicons name="book" size={size} color={color} />
                ),
              }}
            />
            <Tab.Screen
              name="Settings"
              component={SettingsScreen}
              options={{
                tabBarLabel: 'Cài đặt',
                tabBarIcon: ({ color, size }) => (
                  <Ionicons name="settings" size={size} color={color} />
                ),
              }}
            />
          </Tab.Navigator>
        </NavigationContainer>
        <StatusBar style="auto" />
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
}
