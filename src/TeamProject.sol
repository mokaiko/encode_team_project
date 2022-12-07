// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract TeamProject {
    uint256 commentID;

    struct Comment {
        uint256 id;
        address author;
        string content;
        address[] likes;
    }

    mapping(bytes32 => Comment[]) private allComments;

    event CommentAddedEvent(
        uint256 indexed id,
        address indexed author,
        string indexed content
    );

    event LikeAddedEvent(
        bytes32 indexed txHash,
        uint256 indexed id,
        address indexed whoLike
    );

    function addCommentByTxHash(bytes32 _txHash, string memory _content)
        public
    {
        commentID++;
        allComments[_txHash].push(
            Comment({
                id: commentID,
                author: msg.sender,
                content: _content,
                likes: new address[](0)
            })
        );
        emit CommentAddedEvent(commentID, msg.sender, _content);
    }

    function getCommentsByTxHash(bytes32 _txHash)
        public
        view
        returns (Comment[] memory)
    {
        return allComments[_txHash];
    }

    function addLikeByTxHashCommentID(bytes32 _txHash, uint256 _id)
        public
        returns (bool)
    {
        Comment[] storage commentsInOneHash = allComments[_txHash];

        // There are many comments in a tx hash, find out the comment you need by ID.
        for (uint256 i = 0; i < commentsInOneHash.length; i++) {
            if (commentsInOneHash[i].id == _id) {
                // There are many likes in a comment, check if the user has already liked.
                for (
                    uint256 j = 0;
                    j < commentsInOneHash[i].likes.length;
                    j++
                ) {
                    if (commentsInOneHash[i].likes[j] == msg.sender) {
                        return false;
                    }
                }
                commentsInOneHash[i].likes.push(msg.sender);
                emit LikeAddedEvent(_txHash, _id, msg.sender);
                return true;
            }
        }
        return false;
    }
}
