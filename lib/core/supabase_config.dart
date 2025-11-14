import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String supabasePublishableKey = String.fromEnvironment(
  'SUPABASE_PUB_KEY',
);

final supabase = Supabase.instance.client;
