import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../controllers/language_controller.dart';

class NewSearchScreen extends StatefulWidget {
  const NewSearchScreen({super.key});

  @override
  State<NewSearchScreen> createState() => _NewSearchScreenState();
}

class _NewSearchScreenState extends State<NewSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final LanguageController _languageController = Get.find<LanguageController>();
  
  List<String> _searchSuggestions = [];
  List<String> _trendingHashtags = [];
  bool _isLoading = false;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _loadTrendingHashtags();
    _loadSearchSuggestions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTrendingHashtags() async {
    setState(() {
      _trendingHashtags = [
        'ahmed yousef',
        'فيديو الدكتوره بان الاصلي',
        'ريال مدريد يتحرك لضم ادم وارتون',
        'بيبي بيبي اطفال',
        'تونذ البيات الجديد',
        'lord لورد',
        'hamza alhamedi',
        'Gabriela Dance trend',
        'bilalhaddad',
        'OMAR',
      ];
    });
  }

  Future<void> _loadSearchSuggestions() async {
    setState(() {
      _searchSuggestions = [
        'ahmed yousef',
        'فيديو الدكتوره بان الاصلي',
        'ريال مدريد يتحرك لضم ادم وارتون',
        'بيبي بيبي اطفال',
        'تونذ البيات الجديد',
        'lord لورد',
        'hamza alhamedi',
        'Gabriela Dance trend',
        'bilalhaddad',
        'OMAR',
      ];
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _showSuggestions = query.isNotEmpty;
    });
  }

  void _selectSuggestion(String suggestion) {
    _searchController.text = suggestion;
    setState(() {
      _showSuggestions = false;
    });
    _performSearch(suggestion);
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _showSuggestions = false;
    });

    // Simulate search delay
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Back Button
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      _languageController.isArabic 
                          ? Icons.arrow_forward_ios 
                          : Icons.arrow_back_ios,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  
                  // Search Field
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        onSubmitted: _performSearch,
                        textAlign: _languageController.isArabic 
                            ? TextAlign.right 
                            : TextAlign.left,
                        decoration: InputDecoration(
                          hintText: _languageController.isArabic 
                              ? 'ahmed yousef' 
                              : 'Search...',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Search Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () => _performSearch(_searchController.text),
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _showSuggestions 
                  ? _buildSearchSuggestions()
                  : _buildTrendingContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    final filteredSuggestions = _searchSuggestions
        .where((suggestion) => suggestion
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Update Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.refresh,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _languageController.isArabic ? 'تحديث' : 'Update',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Suggestions List
          Expanded(
            child: ListView.builder(
              itemCount: filteredSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = filteredSuggestions[index];
                final isPopular = index < 3;
                
                return ListTile(
                  onTap: () => _selectSuggestion(suggestion),
                  title: Row(
                    children: [
                      // Red dot for popular searches
                      if (isPopular)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      if (isPopular) const SizedBox(width: 12),
                      
                      // Suggestion text
                      Expanded(
                        child: Text(
                          suggestion,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 16,
                          ),
                          textAlign: _languageController.isArabic 
                              ? TextAlign.right 
                              : TextAlign.left,
                        ),
                      ),
                      
                      // Trending indicator
                      if (isPopular)
                        Text(
                          _languageController.isArabic ? 'مر رائج' : 'Trending',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Bottom text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _languageController.isArabic 
                  ? 'ساعدنا على التحسين. | معرفة المزيد'
                  : 'Help us improve. | Learn more',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingContent() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "May interest you" header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _languageController.isArabic ? 'قد يعجبك' : 'May interest you',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headlineMedium?.color,
              ),
            ),
          ),
          
          // Trending hashtags list
          Expanded(
            child: ListView.builder(
              itemCount: _trendingHashtags.length,
              itemBuilder: (context, index) {
                final hashtag = _trendingHashtags[index];
                final isPopular = index < 3;
                
                return ListTile(
                  onTap: () => _selectSuggestion(hashtag),
                  title: Row(
                    children: [
                      // Red dot for popular hashtags
                      if (isPopular)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      if (isPopular) const SizedBox(width: 12),
                      
                      // Hashtag text
                      Expanded(
                        child: Text(
                          hashtag,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: _languageController.isArabic 
                              ? TextAlign.right 
                              : TextAlign.left,
                        ),
                      ),
                      
                      // Trending indicator
                      if (isPopular)
                        Text(
                          _languageController.isArabic ? 'مر رائج' : 'Trending',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Bottom text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _languageController.isArabic 
                  ? 'ساعدنا على التحسين. | معرفة المزيد'
                  : 'Help us improve. | Learn more',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}