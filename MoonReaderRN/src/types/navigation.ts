/**
 * Navigation Types
 * Type definitions for React Navigation
 */

import { NavigatorScreenParams } from '@react-navigation/native';

export type RootTabParamList = {
  Library: undefined;
  Reader: undefined;
  Settings: undefined;
};

export type NavigationProps = {
  navigation: any; // Will be properly typed later
  route: any;
};

