// For Android Emulator, use 10.0.2.2 to access host localhost
// For Physical Device, use your computer's LAN IP (e.g., 192.168.1.x)
const String baseUrl = "http://al-khaliq.org";
const String registerUrl = "$baseUrl/api/register";
const String refreshUrl = "$baseUrl/onboarding/api/access-token/";

const String loginUrl = "$baseUrl/api/login";

const String userUrl = "$baseUrl/api/user";

const String genreUrl = "$baseUrl/api/genre/list";
const String allSongsUrl = "$baseUrl/api/music/list";

const String getPlaylistUrl = "$baseUrl/api/playlists"; // GET
const String getPlaylistSongsUrl = "$baseUrl/api/playlists/"; // GET {id}/music
const String createPlaylistUrl = "$baseUrl/api/playlists/create"; // POST
const String addSongToPlaylistUrl = "$baseUrl/api/playlists/music/add"; // POST
const String removeSongFromPlaylistUrl =
    "$baseUrl/api/playlists/music/remove"; // POST
const String deletePlaylistUrl = "$baseUrl/api/playlists/delete/"; // POST {id}
const String renamePlaylistUrl = "$baseUrl/api/playlists/rename/"; // POST {id}

const String newReleaseUrl = "$baseUrl/api/new/release";
const String recentlyPlayedUrl = "$baseUrl/api/recently/played/list";
const String addRecentlyPlayedUrl = "$baseUrl/api/recently/played/add";
const String myFavouritesUrl = "$baseUrl/api/favorite/music/list";
const String addFavouriteUrl = "$baseUrl/api/favorite/add";
const String removeFromFavoriteUrl = "$baseUrl/api/favorite/remove";
const String socialurl = "$baseUrl/api/social_login";
const String subscription = "$baseUrl/api/subscriptions";
