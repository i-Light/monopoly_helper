Drop city photos here, named after each city's index from
`lib/data/datasets/cities_data.dart` (e.g. `0.jpg`, `1.jpg`, ...).

Until a photo exists for a given index, `CityImageFrame` automatically
falls back to a themed placeholder (the city's board color + a landmark
icon + its name), so the app works fine with this folder empty.
