// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ImmutablePoem {

    struct Poem {
        string title;
        string content;
        address author;
        uint256 timestamp;
        uint256 totalStars;
        uint256 totalRatings;
    }

    mapping(uint256 => Poem) public poems;
    uint256 public poemCount;

    event NewPoem(uint256 indexed poemId, address indexed author);
    event PoemRated(uint256 indexed poemId, uint8 stars);

    function publishPoem(string memory _title, string memory _content) public {
        poems[poemCount] = Poem({
            title: _title,
            content: _content,
            author: msg.sender,
            timestamp: block.timestamp,
            totalStars: 0,
            totalRatings: 0
        });

        emit NewPoem(poemCount, msg.sender);
        poemCount++;
    }

    function ratePoem(uint256 _poemId, uint8 _stars) public {
        require(_stars >= 1 && _stars <= 5, "Stars must be between 1 and 5");

        Poem storage p = poems[_poemId];
        p.totalStars += _stars;
        p.totalRatings += 1;

        emit PoemRated(_poemId, _stars);
    }

    function getAverageRating(uint256 _poemId) public view returns (uint256) {
        Poem storage p = poems[_poemId];
        if (p.totalRatings == 0) {
            return 0;
        }
        return p.totalStars / p.totalRatings;
    }
}
