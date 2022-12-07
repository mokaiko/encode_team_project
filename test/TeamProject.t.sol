// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "../src/TeamProject.sol";

contract TeamProjectTest is Test {
    TeamProject public project;
    bytes32 txHash1 =
        0x7ac993a669e75c722e5f24aedcae50869451b1cf30e770f8e62c8b60bf72365f;
    bytes32 txHash2 =
        0x7ac993a669e75c722e5f24aedcae50869451b1cf30e770f8e62c8b60bf723650;

    function setUp() public {
        project = new TeamProject();
    }

    function testComment() public {
        vm.startPrank(address(0x1));
        project.addCommentByTxHash(txHash1, "The first msg");
        TeamProject.Comment[] memory comments = project.getCommentsByTxHash(
            txHash1
        );
        assertEq(comments.length, 1);
        assertEq(comments[0].author, address(0x1));
        assertEq(comments[0].content, "The first msg");
        assertEq(comments[0].likes.length, 0);

        vm.expectRevert();
        project.addCommentByTxHash(txHash1, "The fail msg");

        project.addCommentByTxHash(txHash2, "The 2nd msg");
        TeamProject.Comment[] memory comments2 = project.getCommentsByTxHash(
            txHash2
        );
        assertEq(comments2.length, 1);
        assertEq(comments2[0].author, address(0x1));
        assertEq(comments2[0].content, "The 2nd msg");
        assertEq(comments2[0].likes.length, 0);

        vm.expectRevert();
        project.addCommentByTxHash(txHash2, "The fail 2 msg");

        vm.stopPrank();

        vm.startPrank(address(0x2));
        project.addCommentByTxHash(txHash1, "The 3rd msg");
        TeamProject.Comment[] memory comments3 = project.getCommentsByTxHash(
            txHash1
        );
        assertEq(comments3.length, 2);
        assertEq(comments3[1].author, address(0x2));
        assertEq(comments3[1].content, "The 3rd msg");
        assertEq(comments3[1].likes.length, 0);

        vm.stopPrank();
    }

    function testLike() public {
        vm.startPrank(address(0x1));
        project.addCommentByTxHash(txHash1, "The first msg");
        project.addLikeByTxHashAuthor(txHash1, address(0x1));

        TeamProject.Comment[] memory comments = project.getCommentsByTxHash(
            txHash1
        );
        assertEq(comments[0].likes.length, 1);
        assertEq(comments[0].likes[0], address(0x1));

        vm.expectRevert();
        project.addLikeByTxHashAuthor(txHash1, address(0x1));

        vm.stopPrank();

        vm.startPrank(address(0x2));
        project.addLikeByTxHashAuthor(txHash1, address(0x1));

        TeamProject.Comment[] memory comments2 = project.getCommentsByTxHash(
            txHash1
        );
        assertEq(comments2[0].likes.length, 2);
        assertEq(comments2[0].likes[0], address(0x1));
        assertEq(comments2[0].likes[1], address(0x2));

        vm.stopPrank();
    }
}
