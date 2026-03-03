import 'package:flutter/material.dart';
import 'food_model.dart';

// =============================================================================
//  DATA CLASSES
// =============================================================================

class CartItem {
  final FoodModel food;
  int quantity;
  double unitPrice; // Stores the price including extras
  List<String>? selectedExtras;
  CartItem({
    required this.food,
    this.quantity = 1,
    required this.unitPrice,
    this.selectedExtras,
  });
}

class Order {
  final String id, status;
  final List<CartItem> items;
  final double total;
  final DateTime date;
  Order({
    required this.id,
    required this.status,
    required this.items,
    required this.total,
    required this.date,
  });
}

class User {
  String name;
  String email;
  String password; // Add this field
  String phone; // Add this field
  int loyaltyPoints;

  User({
    required this.name,
    required this.email,
    this.password = "", // Initialize as empty string
    this.phone = "", // Initialize as empty string
    this.loyaltyPoints = 0,
  });
}

class Reservation {
  final String id, time, status;
  final DateTime date;
  final int guests;
  Reservation({
    required this.id,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
  });
}

// =============================================================================
//  DISH DETAIL — per-dish structured content
// =============================================================================

class DishDetail {
  final List<String> ingredientKeys;
  final List<String> allergenKeys;
  final Alignment imageAlignment;

  const DishDetail({
    required this.ingredientKeys,
    required this.allergenKeys,
    this.imageAlignment = Alignment.center,
  });
}

// =============================================================================
//  APP DATA
// =============================================================================

class AppData {
  static List<CartItem> cart = [];
  static List<Order> orders = [];
  static List<Reservation> reservations = [];
  static User currentUser =
      User(name: 'Guest User', email: 'guest@example.com', loyaltyPoints: 150);

  static String selectedLanguage = 'en';

  static final Map<String, DishDetail> dishDetails = {
    'grilled sirloin steak': const DishDetail(
      ingredientKeys: [
        'ing_sirloin_beef',
        'ing_rosemary',
        'ing_thyme',
        'ing_garlic',
        'ing_butter',
        'ing_sea_salt',
        'ing_black_pepper',
        'ing_olive_oil',
      ],
      allergenKeys: ['alg_dairy', 'alg_sulphites'],
      imageAlignment: Alignment.center,
    ),
    'beluga caviar': const DishDetail(
      ingredientKeys: [
        'ing_beluga_caviar',
        'ing_blinis',
        'ing_creme_fraiche',
        'ing_shallots',
        'ing_lemon',
        'ing_chives',
      ],
      allergenKeys: ['alg_fish', 'alg_eggs', 'alg_gluten', 'alg_dairy'],
      imageAlignment: Alignment.topCenter,
    ),
    'east coast citrus-garlic': const DishDetail(
      ingredientKeys: [
        'ing_oysters',
        'ing_lemon_zest',
        'ing_garlic',
        'ing_parsley',
        'ing_shallots',
        'ing_white_wine',
        'ing_butter',
      ],
      allergenKeys: ['alg_shellfish', 'alg_dairy', 'alg_sulphites'],
      imageAlignment: Alignment.center,
    ),
    'wagyu a5 steak': const DishDetail(
      ingredientKeys: [
        'ing_wagyu_beef',
        'ing_maldon_salt',
        'ing_wasabi',
        'ing_daikon',
        'ing_soy_sauce',
        'ing_yuzu',
        'ing_microgreens',
      ],
      allergenKeys: ['alg_soy', 'alg_sulphites'],
      imageAlignment: Alignment.centerLeft,
    ),
  };

  static DishDetail? getDishDetail(String rawName) =>
      dishDetails[rawName.toLowerCase().trim()];

  // ── Translation maps ───────────────────────────────────────────────────────

  static const Map<String, String> _en = {
    'Favourites': 'Favourites',
    'no_fav_yet': 'Your palate awaits its first favourite.',
    'Added to favorites': 'Added to favorites',
    'Removed from favorites': 'Removed from favorites',
    'cat_non_veg': 'Non-Veg',
    'cat_veg': 'Vegetarian',
    'cat_salad': 'Salads',
    'cat_dessert': 'Desserts',
    'app_title': 'The Grand Atelier',
    'search_hint': 'Discover Culinary Delights',
    'search_food': 'Search dishes...',
    'favourites_title': 'Your Curated Selection',
    'no_items_found': 'No items available.',
    'no_results': 'No results found.',
    'cat_nonveg': 'Non Vegetarian',
    'settings': 'Settings',
    'language': 'Language',
    'Order History': 'Order History',
    'All': 'All',
    'Completed': 'Completed',
    'Cancelled': 'Cancelled',
    'Upcoming': 'Upcoming',
    'No orders yet': 'No orders yet',
    'January': 'January',
    'February': 'February',
    'March': 'March',
    'April': 'April',
    'May': 'May',
    'June': 'June',
    'July': 'July',
    'August': 'August',
    'September': 'September',
    'October': 'October',
    'November': 'November',
    'December': 'December',
    'select language': 'Select Language',
    'notifications': 'Turn on Notifications',
    'edit profile': 'Edit Profile',
    'logout': 'Log Out',
    'sign_out_desc': 'Sign out of your account',
    'login_title': 'Log In',
    'email_hint': 'Email',
    'password_hint': 'Password',
    'login_button': 'Log In',
    'register_button': 'Create Account',
    'forgot_password': 'Forgot Password?',
    'sign_up': 'Sign Up',
    'login_failed': 'Login failed.',
    'name_hint': 'Full Name',
    'phone_hint': 'Phone Number',
    'Reservation': 'Reservation',
    'Select Date': 'Select Date',
    'Arrival Time': 'Arrival Time',
    'Number of Guests': 'Number of Guests',
    'Reservation Duration [hrs]': 'Reservation Duration [hrs]',
    'at': 'at',
    'Confirm': 'Confirm',
    'Cancel': 'Cancel',
    'Please log in first': 'Please log in first',
    'Reservation request sent! Check your email.':
        'Reservation request sent! Check your email.',
    'Error': 'Error',
    'confirm_password_hint': 'Confirm Password',
    'please_fill_all': 'Please fill all fields.',
    'passwords_dont_match': 'Passwords do not match.',
    'reg_failed': 'Registration failed.',
    'save_error': 'Error saving user data.',
    'user_not_found': 'Account not found.',
    'invalid_credential_msg': 'Invalid email or password.',
    'lbl_description': 'About this dish',
    'lbl_ingredients': 'Ingredients',
    'lbl_allergens': 'Allergens',
    'lbl_quantity': 'Quantity',
    'lbl_total': 'Total',
    'lbl_add_to_cart': 'Add to Cart',
    'lbl_customisation': 'Customization',
    'lbl_total_price': 'Total Price',
    'Regular': 'Regular',
    'Extra Sauce': 'Extra Sauce',
    'Extra Cheese': 'Extra Cheese',
    'CHECKOUT': 'CHECKOUT',
    'ORDER SUMMARY': 'ORDER SUMMARY',
    'Subtotal': 'Subtotal',
    'Tax (10%)': 'Tax (10%)',
    'TOTAL': 'TOTAL',
    'PAYMENT METHOD': 'PAYMENT METHOD',
    'CARD DETAILS': 'CARD DETAILS',
    'CARD NUMBER': 'CARD NUMBER',
    'EXPIRY': 'EXPIRY',
    'CVV': 'CVV',
    'CARD HOLDER': 'CARD HOLDER',
    'FULL NAME': 'FULL NAME',
    'CONFIRM PAYMENT': 'CONFIRM PAYMENT',
    'PAYMENT SUCCESSFUL': 'PAYMENT SUCCESSFUL',
    'DIGITAL RECEIPT': 'DIGITAL RECEIPT',
    'Transaction ID': 'Transaction ID',
    'Date': 'Date',
    'TOTAL PAID': 'TOTAL PAID',
    'BACK TO HOME': 'BACK TO HOME',
    'Rewards': 'Rewards',
    'POINT': 'Point',
    'Redeem': 'Redeem',
    'Grilled Sirloin Steak': 'Grilled Sirloin Steak',
    'For 2 persons': 'For 2 persons',
    '50% discount on everything': '50% Discount on everything',
    'Limited offer': 'Limited offer',
    'Product': 'Product',
    'User Info & Preferences': 'User Info & Preferences',
    'Edit Profile': 'Edit Profile',
    'Name': 'Name',
    'Email': 'Email',
    'Password': 'Password',
    'Phone Number': 'Phone Number',
    'Profile Updated': 'Profile Updated',
    'Favourite & Recommendation': 'Favourite & Recommendation',
    'Loyalty & Rewards': 'Loyalty & Rewards',
    'Payment & Security': 'Payment & Security',
    'grilled sirloin steak': 'Herb-Crusted Aged Sirloin',
    'beluga caviar': 'Reserve Beluga Caviar Imperial',
    'east coast citrus-garlic': 'Citrus-Infused East Coast Oysters',
    'wagyu a5 steak': 'Miyazaki A5 Wagyu Ribeye',
    'prime aged beef sirloin grilled to perfection with aromatic herbs':
        'Hand-selected from our master butcher\'s finest dry-aged cuts, this sirloin is seasoned with fragrant rosemary, crushed thyme, and a generous finish of golden churned butter. Seared over an open flame to a perfect medium-rare, it arrives at your table with a smoke-kissed crust and a blush-pink, melt-in-your-mouth centre.',
    'exquisite beluga caviar served with traditional accompaniments':
        'Sourced exclusively from the pristine waters of the Caspian Sea, our Beluga caviar is served at precisely the correct temperature on a mother-of-pearl spoon. Each pearl bursts with a delicate, briny richness that finishes with an unmistakable note of the sea. Accompanied by warm blinis, cold crème fraîche, and finely minced shallots — an experience of pure, unapologetic luxury.',
    'chilled east coast oysters with a signature citrus garlic zest':
        'Harvested at dawn from the cold Atlantic shores, these East Coast oysters arrive live and briny, their shells hand-shucked to order. A vibrant mignonette of charred shallots, citrus zest, and a touch of roasted garlic lifts each oyster\'s natural sweetness into something extraordinary. Served on a bed of crushed ice with wedges of bright lemon — cool, elegant, and utterly refreshing.',
    'world class a5 wagyu beef with unparalleled marbling and flavor':
        'Imported directly from the Miyazaki prefecture in Japan, this A5 Wagyu ribeye boasts an extraordinary BMS score of 12 — the highest grade achievable. The intricate web of fat that runs through every fibre dissolves at body temperature, coating your palate in a wave of deep, buttery richness. Finished with hand-harvested Maldon sea salt and a whisper of yuzu, this is a dish that demands to be savoured, slowly.',
    // Descriptions (Keys are the exact text from your images)
    'Grilled Sirloin Steak is a classic luxury cut known for its balanced marbling, robust beef flavor, and firm yet tender texture. Expertly seasoned with sea salt, cracked pepper, and aromatic herbs, it is seared over high heat to develop a rich crust while maintaining a juicy interior. Often finished with garlic butter or paired with roasted vegetables and fine wine, this steak delivers a refined yet hearty dining experience.':
        'Grilled Sirloin Steak is a classic luxury cut known for its balanced marbling, robust beef flavor, and firm yet tender texture. Expertly seasoned with sea salt, cracked pepper, and aromatic herbs, it is seared over high heat to develop a rich crust while maintaining a juicy interior. Often finished with garlic butter or paired with roasted vegetables and fine wine, this steak delivers a refined yet hearty dining experience.',

    'Beluga caviar comes from the Beluga sturgeon, prized for its large, delicate pearls and buttery texture. Known for its subtle briny flavor and smooth finish, it is often served chilled on mother-of-pearl spoons to preserve its refined taste. Due to strict regulations and rarity, Beluga caviar is one of the most expensive gourmet foods globally.':
        'Beluga caviar comes from the Beluga sturgeon, prized for its large, delicate pearls and buttery texture. Known for its subtle briny flavor and smooth finish, it is often served chilled on mother-of-pearl spoons to preserve its refined taste. Due to strict regulations and rarity, Beluga caviar is one of the most expensive gourmet foods globally.',

    'East Coast Citrus-Garlic is a bright, flavor-forward preparation inspired by coastal cuisine. Fresh citrus zest and juice—often lemon or orange—blend with minced garlic, olive oil, and subtle herbs to create a bold yet refreshing marinade or finishing sauce. Commonly paired with seafood, grilled poultry, or shellfish, it enhances natural flavors with a balance of acidity, aromatics, and light savory depth, delivering a clean and elegant coastal taste profile.':
        'East Coast Citrus-Garlic is a bright, flavor-forward preparation inspired by coastal cuisine. Fresh citrus zest and juice—often lemon or orange—blend with minced garlic, olive oil, and subtle herbs to create a bold yet refreshing marinade or finishing sauce. Commonly paired with seafood, grilled poultry, or shellfish, it enhances natural flavors with a balance of acidity, aromatics, and light savory depth, delivering a clean and elegant coastal taste profile.',
    'ing_sirloin_beef': 'Dry-aged prime sirloin beef',
    'My Cart List': 'My Cart List',
    'Tax': 'Tax',
    'Total': 'Total',
    'PROCEED TO CHECKOUT': 'PROCEED TO CHECKOUT',
    'ing_rosemary': 'Fresh rosemary',
    'ing_thyme': 'Fresh thyme',
    'ing_garlic': 'Roasted garlic',
    'general_settings': 'General Settings',
    'edit_profile': 'Edit Profile',
    'account_settings': 'Account Settings',
    'push_notification': 'Push Notification',
    'dark_mode': 'Dark Mode',
    'languages': 'Languages',
    'log_out': 'Log Out',
    'logout_confirm': 'Are you sure you want to log out?',
    'cancel': 'Cancel',
    'ing_butter': 'Churned butter',
    'ing_sea_salt': 'Fleur de sel',
    'ing_black_pepper': 'Cracked black pepper',
    'Monday': 'Monday',
    'Tuesday': 'Tuesday',
    'sign_up_title': "Sign up",
    'forgot_password_title': 'Password Recovery',
    'forgot_password_subtitle': 'Enter your email to reset your password',
    'send_link_button': 'Send Link',
    'check_email_title': 'Check Your Email',
    'recovery_sent_msg': 'A recovery link has been sent to your inbox.',
    'back_to_login': 'Back to Login',
    'please_enter_email': 'Please enter your email',
    'no_account_found': 'No account found with this email.',
    'invalid_email_format': 'Please enter a valid email address.',
    'Wednesday': 'Wednesday',
    'Thursday': 'Thursday',
    'Friday': 'Friday',
    'Saturday': 'Saturday',
    'remember_me': 'Remember me',
    'Sunday': 'Sunday',
    'ing_olive_oil': 'Extra-virgin olive oil',
    'ing_beluga_caviar': 'Wild Beluga caviar',
    'ing_blinis': 'Buckwheat blinis',
    'ing_creme_fraiche': 'Crème fraîche',
    'ing_shallots': 'Finely minced shallots',
    'ing_lemon': 'Fresh lemon',
    'Citrus-Infused East Coast Oysters': 'Citrus-Infused East Coast Oysters',
    'Beluga Caviar': 'Beluga Caviar',
    'ing_chives': 'Snipped chives',
    'ing_oysters': 'Live East Coast oysters',
    'ing_lemon_zest': 'Citrus zest',
    'ing_parsley': 'Flat-leaf parsley',
    'ing_white_wine': 'Dry white wine',
    'ing_wagyu_beef': 'A5 Miyazaki Wagyu ribeye',
    'ing_maldon_salt': 'Maldon sea salt',
    'ing_wasabi': 'Fresh wasabi',
    'ing_daikon': 'Pickled daikon',
    'ing_soy_sauce': 'Aged tamari soy sauce',
    'ing_yuzu': 'Yuzu juice',
    'ing_microgreens': 'Seasonal microgreens',
    'alg_dairy': 'Dairy',
    'alg_sulphites': 'Sulphites',
    'alg_fish': 'Fish',
    'alg_eggs': 'Eggs',
    'alg_gluten': 'Gluten',
    'alg_shellfish': 'Shellfish',
    'alg_soy': 'Soy',
  };

  static const Map<String, String> _es = {
    'app_title': 'El Palacio Gastronómico',
    'search_hint': 'Buscar platillos...',
    'search_food': 'Buscar platillos...',
    'cat_non_veg': 'No vegetariano',
    'cat_veg': 'Vegetariano',
    'cat_salad': 'Ensaladas',
    'favourites_title': 'Mis favoritos',
    'no_fav_yet': 'Aún no tienes favoritos.',
    'no_items_found': 'No hay platos disponibles.',
    'no_results': 'Sin resultados.',
    'login_title': 'Iniciar sesión',
    'email_hint': 'Correo electrónico',
    'password_hint': 'Contraseña',
    'login_button': 'Entrar',
    'register_button': 'Crear cuenta',
    'Reservation': 'Reserva',
    'Select Date': 'Seleccionar fecha',
    'Arrival Time': 'Hora de llegada',
    'Number of Guests': 'Número de invitados',
    'Reservation Duration [hrs]': 'Duración de la reserva [hrs]',
    'at': 'a las',
    'Confirm': 'Confirmar',
    'Cancel': 'Cancelar',
    'Please log in first': 'Por favor, inicie sesión primero',
    'Beluga Caviar': 'Caviar Beluga',
    'forgot_password_title': 'Recuperar Contraseña',
    'forgot_password_subtitle':
        'Introduce tu correo para restablecer tu contraseña',
    'send_link_button': 'Enviar Enlace',
    'check_email_title': 'Revisa tu Correo',
    'recovery_sent_msg':
        'Se ha enviado un enlace de recuperación a tu bandeja.',
    'back_to_login': 'Volver al Inicio',
    'please_enter_email': 'Por favor, introduce tu correo',
    'no_account_found': 'No existe cuenta con este correo.',
    'invalid_email_format': 'Introduce un correo válido.',
    'Citrus-Infused East Coast Oysters': 'Ostras de la Costa Este con Cítricos',
    'Reservation request sent! Check your email.':
        '¡Solicitud enviada! Revisa tu correo.',
    'Error': 'Error',
    'Order History': 'Historial de Pedidos',
    'All': 'Todos',
    'Completed': 'Completado',
    'Cancelled': 'Cancelado',
    'Upcoming': 'Próximos',
    'No orders yet': 'Aún no hay pedidos',
    'January': 'Enero',
    'February': 'Febrero',
    'March': 'Marzo',
    'April': 'Abril',
    'May': 'Mayo',
    'June': 'Junio',
    'July': 'Julio',
    'August': 'Agosto',
    'September': 'Septiembre',
    'October': 'Octubre',
    'November': 'Noviembre',
    'December': 'Diciembre',

    // Days of the Week
    'Monday': 'Lunes',
    'Tuesday': 'Martes',
    'Wednesday': 'Miércoles',
    'Thursday': 'Jueves',
    'sign_up_title': 'Regístrate',
    'Friday': 'Viernes',
    'Saturday': 'Sábado',
    'Sunday': 'Domingo',
    'forgot_password': 'Olvidaste tu contraseña?',
    'sign_up': 'Registrarse',
    'login_failed': 'Error al iniciar sesión.',
    'name_hint': 'Nombre completo',
    'phone_hint': 'Número de teléfono',
    'confirm_password_hint': 'Confirmar contraseña',
    'please_fill_all': 'Por favor, completa todos los campos.',
    'passwords_dont_match': 'Las contraseñas no coinciden.',
    'reg_failed': 'Error en el registro.',
    'save_error': 'Error al guardar los datos.',
    'user_not_found': 'Cuenta no encontrada.',
    'invalid_credential_msg': 'Correo o contraseña incorrectos.',
    'settings': 'Ajustes',
    'language': 'Idioma',
    'select language': 'Seleccionar idioma',
    'notifications': 'Activar notificaciones',
    'edit profile': 'Editar perfil',
    'logout': 'Cerrar sesión',
    'sign_out_desc': 'Cerrar sesión en su cuenta',
    'lbl_description': 'Sobre este plato',
    'lbl_ingredients': 'Ingredientes',
    'Rewards': 'Recompensas',
    'POINT': 'Punto',
    'general_settings': 'Ajustes Generales',
    'edit_profile': 'Editar Perfil',
    'account_settings': 'Ajustes de Cuenta',
    'push_notification': 'Notificación Push',
    'dark_mode': 'Modo Oscuro',
    'languages': 'Idiomas',
    'log_out': 'Cerrar Sesión',
    'logout_confirm': 'Está seguro de que desea cerrar sesión?',
    'cancel': 'Cancelar',
    'Redeem': 'Canjear',
    'For 2 persons': 'Para 2 personas',
    '50% discount on everything': '50% de descuento en todo',
    'Limited offer': 'Oferta limitada',
    'Favourites': 'Favoritos',
    'Added to favorites': 'Añadido a favoritos',
    'Removed from favorites': 'Eliminado de favoritos',
    'cat_dessert': 'Postres',
    'lbl_allergens': 'Alérgenos',
    'User Info & Preferences': 'Información y Preferencias',
    'Favourite & Recommendation': 'Favoritos y Recomendaciones',
    'Loyalty & Rewards': 'Fidelidad y Recompensas',
    'Payment & Security': 'Pago y Seguridad',
    'lbl_quantity': 'Cantidad',
    'lbl_total': 'Total',
    'lbl_add_to_cart': 'Añadir al carrito',
    'lbl_customisation': 'Personalización',
    'lbl_total_price': 'Precio Total',
    'Regular': 'Normal',
    'Extra Sauce': 'Extra de salsa',
    'Extra Cheese': 'Extra de queso',
    'grilled sirloin steak': 'Solomillo Añejo a las Finas Hierbas',
    'beluga caviar': 'Caviar Beluga Imperial',
    'east coast citrus-garlic': 'Ostras al Ajillo con Toque Cítrico',
    'wagyu a5 steak': 'Corte Wagyu A5 de Primera',
    'PAYMENT SUCCESSFUL': 'PAGO EXITOSO',
    'DIGITAL RECEIPT': 'RECIBO DIGITAL',
    'Transaction ID': 'ID de Transacción',
    'Date': 'Fecha',
    'TOTAL PAID': 'TOTAL PAGADO',
    'BACK TO HOME': 'VOLVER AL INICIO',
    'Product': 'Producto',
    'My': 'Mi',
    'Cart List': 'Lista de Carrito',
    'Subtotal': 'Subtotal',
    'Tax': 'Impuestos',
    'Total': 'Total',
    'PROCEED TO CHECKOUT': 'CONTINUAR AL PAGO',
    'CHECKOUT': 'CAJA',
    'Edit Profile': 'Editar Perfil',
    'Name': 'Nombre',
    'Email': 'Correo Electrónico',
    'Password': 'Contraseña',
    'Phone Number': 'Número de Teléfono',
    'Profile Updated': 'Perfil Actualizado',
    'ORDER SUMMARY': 'RESUMEN DEL PEDIDO',
    'Tax (10%)': 'Impuesto (10%)',
    'TOTAL': 'TOTAL',
    'PAYMENT METHOD': 'MÉTODO DE PAGO',
    'CARD DETAILS': 'DATOS DE LA TARJETA',
    'CARD NUMBER': 'NÚMERO DE TARJETA',
    'EXPIRY': 'VENCIMIENTO',
    'CVV': 'CVV',
    'CARD HOLDER': 'TITULAR DE LA TARJETA',
    'FULL NAME': 'NOMBRE COMPLETO',
    'CONFIRM PAYMENT': 'CONFIRMAR PAGO',
    'prime aged beef sirloin grilled to perfection with aromatic herbs':
        'Seleccionado por nuestro maestro carnicero entre los mejores cortes maduros en seco, este solomillo se sazona con romero fresco, tomillo aromático y una generosa nube de mantequilla dorada. Sellado a fuego vivo hasta alcanzar un punto rosado y jugoso, llega a tu mesa con una costra caramelizada y un interior tierno que se deshace en el paladar.',
    'exquisite beluga caviar served with traditional accompaniments':
        'Procedente de las prístinas aguas del mar Caspio, nuestro caviar Beluga se sirve a la temperatura exacta sobre una cuchara de nácar. Cada perla estalla con una riqueza salina delicada que termina con una inconfundible nota marina. Acompañado de blinis tibios, crème fraîche bien fría y chalotes finamente picados — una experiencia de lujo puro e irrefutable.',
    'chilled east coast oysters with a signature citrus garlic zest':
        'Recolectadas al amanecer en las frías costas del Atlántico, estas ostras llegan vivas y salinas, abiertas a mano en el momento. Una vibrante mignonette de chalotes chamuscados, ralladura cítrica y un toque de ajo asado realza la dulzura natural de cada ostra hasta algo verdaderamente extraordinario. Servidas sobre hielo picado con gajos de limón fresco — frescas, elegantes e irresistiblemente refrescantes.',
    'world class a5 wagyu beef with unparalleled marbling and flavor':
        'Importado directamente de la prefectura de Miyazaki, Japón, este entrecot Wagyu A5 presenta una puntuación BMS de 12 — el grado más alto posible. La intrincada red de grasa que recorre cada fibra se disuelve a temperatura corporal, bañando el paladar en una oleada de cremosa riqueza. Terminado con sal marina Maldon y un susurro de yuzu, este es un plato que exige ser saboreado, lentamente.',
    'ing_sirloin_beef': 'Solomillo de ternera madurado en seco',
    // Descriptions
    'Grilled Sirloin Steak is a classic luxury cut known for its balanced marbling, robust beef flavor, and firm yet tender texture. Expertly seasoned with sea salt, cracked pepper, and aromatic herbs, it is seared over high heat to develop a rich crust while maintaining a juicy interior. Often finished with garlic butter or paired with roasted vegetables and fine wine, this steak delivers a refined yet hearty dining experience.':
        'El Solomillo a la Parrilla es un corte de lujo clásico conocido por su marmoleo equilibrado, robusto sabor a ternera y textura firme pero tierna. Sazonado por expertos con sal marina, pimienta y hierbas aromáticas, se sella a fuego vivo para crear una costra rica manteniendo un interior jugoso. Terminado con mantequilla de ajo o maridado con vegetales asados y vino fino, ofrece una experiencia gastronómica refinada y sustanciosa.',

    'Beluga caviar comes from the Beluga sturgeon, prized for its large, delicate pearls and buttery texture. Known for its subtle briny flavor and smooth finish, it is often served chilled on mother-of-pearl spoons to preserve its refined taste. Due to strict regulations and rarity, Beluga caviar is one of the most expensive gourmet foods globally.':
        'El caviar Beluga proviene del esturión Beluga, apreciado por sus perlas grandes y delicadas y su textura mantecosa. Conocido por su sutil sabor salino y acabado suave, se sirve frío en cucharas de nácar para preservar su gusto refinado. Debido a las estrictas regulaciones y su rareza, es uno de los alimentos gourmet más caros del mundo.',

    'East Coast Citrus-Garlic is a bright, flavor-forward preparation inspired by coastal cuisine. Fresh citrus zest and juice—often lemon or orange—blend with minced garlic, olive oil, and subtle herbs to create a bold yet refreshing marinade or finishing sauce. Commonly paired with seafood, grilled poultry, or shellfish, it enhances natural flavors with a balance of acidity, aromatics, and light savory depth, delivering a clean and elegant coastal taste profile.':
        'Ostras al Ajillo con Toque Cítrico es una preparación vibrante inspirada en la cocina costera. La ralladura y el jugo de cítricos frescos se mezclan con ajo picado, aceite de oliva y hierbas para crear un marinado audaz y refrescante. Realza los sabores naturales con un equilibrio de acidez y profundidad aromática, ofreciendo un perfil de sabor costero limpio y elegante.',

    'Wagyu A5 steak represents the highest possible beef grading in Japan. Its intricate marbling melts at low temperatures, creating a rich, buttery flavor and velvety texture. Often lightly seasoned and seared briefly, this steak delivers an indulgent, melt-in-your-mouth experience that defines culinary luxury.':
        'El filete Wagyu A5 representa la calificación más alta de carne en Japón. Su intrincado marmoleo se funde a bajas temperaturas, creando un sabor rico y mantecoso con una textura aterciopelada. Sellado brevemente, este corte ofrece una experiencia indulgente que se deshace en la boca, definiendo el lujo culinario.',
    'ing_rosemary': 'Romero fresco',
    'ing_thyme': 'Tomillo fresco',
    'ing_garlic': 'Ajo asado',
    'ing_butter': 'Mantequilla batida',
    'ing_sea_salt': 'Fleur de sel',
    'remember_me': 'Recordarme',
    'ing_black_pepper': 'Pimienta negra molida',
    'ing_olive_oil': 'Aceite de oliva virgen extra',
    'ing_beluga_caviar': 'Caviar Beluga salvaje',
    'ing_blinis': 'Blinis de trigo sarraceno',
    'ing_creme_fraiche': 'Crème fraîche',
    'ing_shallots': 'Chalotes finamente picados',
    'ing_lemon': 'Limón fresco',
    'cat_nonveg': 'No vegetariano',
    'ing_chives': 'Cebollino picado',
    'ing_oysters': 'Ostras vivas de la Costa Este',
    'ing_lemon_zest': 'Ralladura de cítricos',
    'ing_parsley': 'Perejil de hoja plana',
    'ing_white_wine': 'Vino blanco seco',
    'ing_wagyu_beef': 'Entrecot Wagyu A5 de Miyazaki',
    'ing_maldon_salt': 'Sal marina Maldon',
    'ing_wasabi': 'Wasabi fresco',
    'ing_daikon': 'Daikon encurtido',
    'ing_soy_sauce': 'Salsa de soja tamari añeja',
    'ing_yuzu': 'Zumo de yuzu',
    'ing_microgreens': 'Microvegetales de temporada',
    'alg_dairy': 'Lácteos',
    'alg_sulphites': 'Sulfitos',
    'alg_fish': 'Pescado',
    'alg_eggs': 'Huevos',
    'alg_gluten': 'Gluten',
    'alg_shellfish': 'Mariscos',
    'alg_soy': 'Soja',
  };

  static const Map<String, String> _fr = {
    'app_title': 'L\'Étoile Gastronomique',
    'search_hint': 'Découvrez nos saveurs',
    'search_food': 'Rechercher des plats...',
    'cat_non_veg': 'Non-Végétarien',
    'Reservation': 'Réservation',
    'Select Date': 'Choisir une date',
    'remember_me': 'Se souvenir de moi',
    'Arrival Time': 'Heure d\'arrivée',
    'Number of Guests': 'Nombre d\'invités',
    'Reservation Duration [hrs]': 'Durée de réservation [hrs]',
    'at': 'à',
    'Confirm': 'Confirmer',
    'Cancel': 'Annuler',
    'sign_up_title': "S'inscrire",
    'Please log in first': 'Veuillez d\'abord vous connecter',
    'Reservation request sent! Check your email.':
        'Demande envoyée ! Vérifiez vos e-mails.',
    'forgot_password_title': 'Récupérer le mot de passe',
    'forgot_password_subtitle':
        'Entrez votre email pour réinitialiser votre mot de passe',
    'send_link_button': 'Envoyer le lien',
    'check_email_title': 'Vérifiez vos emails',
    'recovery_sent_msg':
        'Un lien de récupération a été envoyé sur votre boîte mail.',
    'back_to_login': 'Retour à la connexion',
    'please_enter_email': 'Veuillez entrer votre email',
    'no_account_found': 'Aucun compte trouvé avec cet email.',
    'invalid_email_format': 'Veuillez entrer un email valide.',
    'Error': 'Erreur',

    // Days of the Week
    'Monday': 'Lundi',
    'Tuesday': 'Mardi',
    'Wednesday': 'Mercredi',
    'Thursday': 'Jeudi',
    'Friday': 'Vendredi',
    'Saturday': 'Samedi',
    'Sunday': 'Dimanche',
    'cat_veg': 'Végétarien',
    'cat_nonveg': 'Non-Végétarien',
    'Favourites': 'Favoris',
    'no_fav_yet': 'Votre palais attend son premier coup de cœur.',
    'Added to favorites': 'Ajouté aux favoris',
    'Removed from favorites': 'Retiré des favoris',
    'Beluga Caviar': 'Caviar Béluga',
    'Citrus-Infused East Coast Oysters': 'Huîtres de la Côte Est aux Agrumes',
    'cat_salad': 'Salades',
    'cat_dessert': 'Desserts',
    'favourites_title': 'Vos Coups de Cœur',
    'no_items_found': 'Aucun article disponible.',

    'no_results': 'Aucun résultat.',
    'Rewards': 'Récompenses',
    'POINT': 'Point',
    'Redeem': 'Échanger',
    'For 2 persons': 'Pour 2 personnes',
    '50% discount on everything': '50% de réduction sur tout',
    'Limited offer': 'Offre limitée',
    'login_title': 'Connexion',
    'Order History': 'Historique des Commandes',
    'All': 'Tout',
    'Completed': 'Terminé',
    'Cancelled': 'Annulé',
    'Upcoming': 'À venir',
    'No orders yet': 'Aucune commande pour le moment',
    'January': 'Janvier',
    'February': 'Février',
    'March': 'Mars',
    'April': 'Avril',
    'May': 'Mai',
    'June': 'Juin',
    'July': 'Juillet',
    'August': 'Août',
    'September': 'Septembre',
    'October': 'Octobre',
    'November': 'Novembre',
    'December': 'Décembre',
    'email_hint': 'E-mail',
    'password_hint': 'Mot de passe',
    'login_button': 'Se connecter',
    'register_button': 'Créer un compte',
    'forgot_password': 'Mot de passe oublié ?',
    'sign_up': 'S\'inscrire',
    'login_failed': 'Échec de la connexion.',
    'name_hint': 'Nom complet',
    'phone_hint': 'Téléphone',
    'confirm_password_hint': 'Confirmer le mot de passe',
    'please_fill_all': 'Veuillez remplir tous les champs.',
    'passwords_dont_match': 'Les mots de passe ne correspondent pas.',
    'reg_failed': 'L\'inscription a échoué.',
    'save_error': 'Erreur lors de l\'enregistrement.',
    'user_not_found': 'Compte non trouvé.',
    'invalid_credential_msg': 'E-mail ou mot de passe invalide.',
    'settings': 'Paramètres',
    'language': 'Langue',
    'select language': 'Choisir la langue',
    'notifications': 'Activer les notifications',
    'edit profile': 'Modifier le profil',
    'logout': 'Déconnexion',
    'sign_out_desc': 'Se déconnecter de votre compte',
    'lbl_description': 'À propos de ce plat',
    'lbl_ingredients': 'Ingrédients',
    'Edit Profile': 'Modifier le Profil',
    'Name': 'Nom',
    'Email': 'E-mail',
    'Password': 'Mot de passe',
    'Phone Number': 'Numéro de téléphone',
    'Profile Updated': 'Profil mis à jour',
    'lbl_allergens': 'Allergènes',
    'lbl_quantity': 'Quantité',
    'lbl_total': 'Total',
    'lbl_add_to_cart': 'Ajouter au panier',
    'lbl_customisation': 'Personnalisation',
    'lbl_total_price': 'Prix Total',
    'Regular': 'Régulier',
    'Extra Sauce': 'Sauce Supplémentaire',
    'Extra Cheese': 'Fromage Supplémentaire',
    'CHECKOUT': 'PAIEMENT',
    'ORDER SUMMARY': 'RÉSUMÉ DE LA COMMANDE',

    'Subtotal': 'Sous-total',
    'Tax (10%)': 'Taxe (10%)',
    'TOTAL': 'TOTAL',
    'PAYMENT METHOD': 'MODE DE PAIEMENT',
    'CARD DETAILS': 'DÉTAILS DE LA CARTE',
    'CARD NUMBER': 'NUMÉRO DE CARTE',
    'EXPIRY': 'EXPIRATION',
    'CVV': 'CVV',
    'CARD HOLDER': 'TITULAIRE DE LA CARTE',
    'FULL NAME': 'NOM COMPLET',
    'CONFIRM PAYMENT': 'CONFIRMER LE PAIEMENT',
    'User Info & Preferences': 'Infos et Préférences',
    'Favourite & Recommendation': 'Favoris et Recommandations',
    'Loyalty & Rewards': 'Fidélité et Récompenses',
    'Payment & Security': 'Paiement et Sécurité',
    'grilled sirloin steak': 'Médaillon de Surlonge Vieillie aux Herbes',
    'beluga caviar': 'Élixir de Caviar Béluga Impérial',
    'general_settings': 'Paramètres Généraux',
    'edit_profile': 'Modifier le Profil',
    'account_settings': 'Paramètres du Compte',
    'push_notification': 'Notification Push',
    'dark_mode': 'Mode Sombre',
    'languages': 'Langues',
    'log_out': 'Déconnexion',
    'logout_confirm': 'Êtes-vous sûr de vouloir vous déconnecter ?',
    'cancel': 'Annuler',
    'east coast citrus-garlic': 'Huîtres de la Côte Est au Zeste d\'Agrumes',
    'wagyu a5 steak': 'Entrecôte de Wagyu A5 d\'Origine Noble',
    'prime aged beef sirloin grilled to perfection with aromatic herbs':
        'Sélectionné par notre maître boucher parmi les meilleures pièces de bœuf vieilli à sec, ce faux-filet est assaisonné de romarin frais, de thym parfumé et d\'une généreuse noisette de beurre doré. Saisi sur flamme vive jusqu\'à une cuisson rosée et juteuse, il arrive à votre table avec une croûte caramélisée et un cœur fondant qui se dissout sur le palais.',
    'exquisite beluga caviar served with traditional accompaniments':
        'Issu exclusivement des eaux vierges de la mer Caspienne, notre caviar Béluga est servi à la température exacte sur une cuillère en nacre. Chaque perle éclate d\'une richesse saline délicate, se terminant par une note marine inoubliable. Accompagné de blinis tièdes, de crème fraîche bien froide et d\'échalotes finement ciselées — une expérience de luxe pur et assumé.',
    'chilled east coast oysters with a signature citrus garlic zest':
        'Récoltées à l\'aube sur les froides côtes atlantiques, ces huîtres arrivent vivantes et iodées, ouvertes à la main au moment du service. Une mignonette vibrante d\'échalotes grillées, de zestes d\'agrumes et d\'une touche d\'ail rôti magnifie la douceur naturelle de chaque huître jusqu\'à l\'extraordinaire. Servies sur lit de glace pilée avec des quartiers de citron frais — fraîches, élégantes et infiniment rafraîchissantes.',
    'world class a5 wagyu beef with unparalleled marbling and flavor':
        'Importée directement de la préfecture de Miyazaki au Japon, cette entrecôte de Wagyu A5 affiche un score BMS de 12 — le grade le plus élevé qui soit. Le réseau complexe de gras intramusculaire fond à la température du corps, enveloppant le palais d\'une richesse beurrée et profonde. Finalisée avec du sel de Maldon récolté à la main et une touche de yuzu, ce plat s\'apprécie lentement, saveur après saveur.',
    'ing_sirloin_beef': 'Faux-filet de bœuf vieilli à sec',
    'PAYMENT SUCCESSFUL': 'PAIEMENT RÉUSSI',
    'DIGITAL RECEIPT': 'REÇU NUMÉRIQUE',
    'Transaction ID': 'ID de Transaction',
    'Date': 'Date',
    'TOTAL PAID': 'TOTAL PAYÉ',
    'BACK TO HOME': 'RETOUR À L\'ACCUEIL',
    'Product': 'Produit',
    'My': 'Mon',
    'Cart List': 'Panier',
    'Tax': 'Taxe',
    'Total': 'Total',
    'PROCEED TO CHECKOUT': 'PASSER À LA CAISSE',
    'ing_rosemary': 'Romarin frais',
    'ing_thyme': 'Thym frais',
    'ing_garlic': 'Ail rôti',
    'ing_butter': 'Beurre baratté',
    'ing_sea_salt': 'Fleur de sel',
    'ing_black_pepper': 'Poivre noir concassé',
    'ing_olive_oil': 'Huile d\'olive extra-vierge',
    'ing_beluga_caviar': 'Caviar Béluga sauvage',
    'ing_blinis': 'Blinis au sarrasin',
    'ing_creme_fraiche': 'Crème fraîche',
    'ing_shallots': 'Échalotes finement ciselées',
    'ing_lemon': 'Citron frais',
    'ing_chives': 'Ciboulette ciselée',
    'ing_oysters': 'Huîtres vivantes de la Côte Est',
    'ing_lemon_zest': 'Zestes d\'agrumes',
    'ing_parsley': 'Persil plat',
    'ing_white_wine': 'Vin blanc sec',
    'ing_wagyu_beef': 'Entrecôte de Wagyu A5 de Miyazaki',
    'ing_maldon_salt': 'Sel de Maldon',
    'ing_wasabi': 'Wasabi frais',
    'ing_daikon': 'Daïkon mariné',
    'ing_soy_sauce': 'Sauce soja tamari vieilli',
    'ing_yuzu': 'Jus de yuzu',
    'ing_microgreens': 'Pousses de saison',
    'alg_dairy': 'Produits laitiers',
    'alg_sulphites': 'Sulfites',
    'alg_fish': 'Poisson',
    'alg_eggs': 'Œufs',
    'alg_gluten': 'Gluten',
    'alg_shellfish': 'Crustacés',
    'alg_soy': 'Soja',

    // Descriptions
    'Grilled Sirloin Steak is a classic luxury cut known for its balanced marbling, robust beef flavor, and firm yet tender texture. Expertly seasoned with sea salt, cracked pepper, and aromatic herbs, it is seared over high heat to develop a rich crust while maintaining a juicy interior. Often finished with garlic butter or paired with roasted vegetables and fine wine, this steak delivers a refined yet hearty dining experience.':
        'Le faux-filet grillé est une coupe de luxe classique réputée pour son persillage équilibré et sa saveur robuste. Saisi à feu vif avec des herbes aromatiques pour une croûte savoureuse et un cœur juteux, il est souvent accompagné de beurre à l\'ail et de vin fin pour une expérience raffinée.',

    'Beluga caviar comes from the Beluga sturgeon, prized for its large, delicate pearls and buttery texture. Known for its subtle briny flavor and smooth finish, it is often served chilled on mother-of-pearl spoons to preserve its refined taste. Due to strict regulations and rarity, Beluga caviar is one of the most expensive gourmet foods globally.':
        'Le caviar Béluga, issu de l\'esturgeon Béluga, est prisé pour ses perles délicates et sa texture beurrée. Servi frais sur des cuillères en nacre pour préserver son goût raffiné, c\'est l\'un des produits gastronomiques les plus chers au monde.',

    'East Coast Citrus-Garlic is a bright, flavor-forward preparation inspired by coastal cuisine. Fresh citrus zest and juice—often lemon or orange—blend with minced garlic, olive oil, and subtle herbs to create a bold yet refreshing marinade or finishing sauce. Commonly paired with seafood, grilled poultry, or shellfish, it enhances natural flavors with a balance of acidity, aromatics, and light savory depth, delivering a clean and elegant coastal taste profile.':
        'Une préparation vive inspirée de la cuisine côtière, mêlant zestes d\'agrumes, ail et herbes subtiles. Parfait avec les fruits de mer, il offre un équilibre élégant d\'acidité et de profondeur aromatique.',

    'Wagyu A5 steak represents the highest possible beef grading in Japan. Its intricate marbling melts at low temperatures, creating a rich, buttery flavor and velvety texture. Often lightly seasoned and seared briefly, this steak delivers an indulgent, melt-in-your-mouth experience that defines culinary luxury.':
        'Le bœuf Wagyu A5 représente le sommet de la qualité au Japon. Son persillage fond à basse température pour une saveur riche et une texture veloutée, offrant une expérience luxueuse qui fond dans la bouche.',
  };

  static final Map<String, Map<String, String>> translations = {
    'en': _en,
    'es': _es,
    'fr': _fr,
  };

  // ── Translation lookup ─────────────────────────────────────────────────────

  static String _cleanCompare(String text) =>
      text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '').trim();

  static String trans(String key) {
    Map<String, String> map;

    if (selectedLanguage == 'es') {
      map = _es; // Make sure your Spanish map is named _es
    } else if (selectedLanguage == 'fr') {
      map = _fr;
    } else {
      map = _en;
    }

    // Attempt to find translation (normalized for database strings)
    return map[key.toLowerCase().trim()] ?? map[key] ?? key;
  }
}
