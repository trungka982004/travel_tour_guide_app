class RecommendationController {
  // GET /recommendations
  async getRecommendations(req, res) {
    try {
      // For now, return static recommendations. Replace with dynamic logic as needed.
      const recommendations = [
        { type: 'activity', name: 'Tour kayak', description: 'Khám phá biển bằng kayak', id: 'rec1' },
        { type: 'restaurant', name: 'Blue Sea Restaurant', description: 'Ẩm thực hải sản tươi sống', id: 'rec2' },
        { type: 'service', name: 'Đưa rước sân bay', description: 'Dịch vụ đưa đón tiện lợi', id: 'rec3' },
      ];
      res.status(200).json(recommendations);
    } catch (error) {
      res.status(500).json({ message: 'Failed to fetch recommendations', error: error.message });
    }
  }
}

module.exports = RecommendationController; 