deploy:
	flutter clean
	flutter build web
	firebase deploy

debug:
	flutter run -d chrome
