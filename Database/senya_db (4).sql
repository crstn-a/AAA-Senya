-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 09, 2025 at 12:21 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `senya_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `hash_password` varchar(255) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`user_id`, `name`, `email`, `username`, `hash_password`, `role`, `created_at`, `last_login`, `status`) VALUES
(7, 'Alexies s. Nilo', 'niloalexies@gmail.com', 'user7', '$2b$12$vbtYTyVaoRvh9ewfd.CLhud9QNix9PmPKJmNApy0/pYcV.lmNqtF6', 'admin', '2025-04-13 07:03:22', '2025-04-22 19:16:45', 'active'),
(8, 'Cristina Alipio', 'cristina@gmail.com', 'user8', '$2b$12$fnlfs2U0.UqgmTLt5bzZ.OC54nRxrYh0IousFK6UECzmGSM97EfPK', 'user', '2025-04-14 02:37:08', '2025-04-22 02:09:25', 'active'),
(9, 'Julia Rose Arenas', 'rose@example.com', 'user9', '$2b$12$QI2by3ghsv.rWtFNjdKosO6fJIuWj4SNK2UN/WGjtV569QPJ841yO', 'user', '2025-04-14 03:33:33', '2025-04-13 20:11:06', 'active'),
(10, 'Julia Rose Arena', 'juliarose@gmail.com', 'user10', '$2b$12$0jlmiOpFRBsWAmIWr2fbYepd5HA6R.yDWWhc9CgaIx/cbk042ORtG', 'user', '2025-04-14 05:04:32', '2025-05-07 06:29:55', 'active'),
(11, 'Jenny Amplogio', 'jenny@gmail.com', 'jenny', '$2b$12$f4NPyUM3ZM5d05iaJ0ABAumq03PpbyCfgp/vqnWkL9HWqHpQle962', 'admin', '2025-04-21 14:14:04', '2025-05-07 23:28:37', 'active'),
(12, 'Kim Sunoo', 'sunsun@gmail.com', 'user12', '$2b$12$spDh4mkNfcoI9cHE7BMkTu2V0xyz1AyqTMDPK8HjYxBLVBzlyvY9y', 'user', '2025-04-22 09:28:44', '2025-04-22 02:03:26', 'active'),
(13, 'Jenny Lyn', 'jennya@gmail.com', 'jxnnz', '$2b$12$tD8PXobGswJOru.qU/161eFY3A7pO0kKuDoFdjmVGFDQol/ZIR9ri', 'user', '2025-05-06 11:53:09', '2025-05-09 01:49:15', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `heart_packages`
--

CREATE TABLE `heart_packages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `hearts_amount` int(11) NOT NULL,
  `ruby_cost` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `heart_packages`
--

INSERT INTO `heart_packages` (`id`, `name`, `hearts_amount`, `ruby_cost`) VALUES
(1, 'Single Heart', 1, 10),
(2, 'Triple Hearts', 3, 30),
(3, 'Full Hearts', 5, 45);

-- --------------------------------------------------------

--
-- Table structure for table `lessons`
--

CREATE TABLE `lessons` (
  `id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `rubies_reward` int(11) DEFAULT 0,
  `order_index` int(11) DEFAULT 0,
  `image_url` varchar(255) DEFAULT NULL,
  `status` enum('active','draft','archived') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archived` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `lessons`
--

INSERT INTO `lessons` (`id`, `unit_id`, `title`, `description`, `rubies_reward`, `order_index`, `image_url`, `status`, `created_at`, `updated_at`, `archived`) VALUES
(4133, 8, 'Lesson 1: Introduction', 'Objective: Learn frequently used words in daily conversations related to communication and\r\nlearning.\r\n', 20, 1, NULL, 'active', '2025-04-20 14:05:12', '2025-04-20 17:29:27', 1),
(4135, 8, 'Lesson 2: The Alphabet (A-M)', 'Learn the first half of the alphabet from A to M.', 10, 2, '/static/images/lessons/4135/7be185d9-6eca-4910-8c82-9700f351c4b2.png', 'active', '2025-04-20 14:10:40', '2025-05-06 23:17:02', 0),
(4136, 8, 'Lesson 3: The Alphabet (N-Z)', 'Objective: Learn the second half of the fingerspelled alphabet.', 20, 3, NULL, 'active', '2025-04-20 14:11:26', '2025-04-20 16:00:12', 1),
(4137, 9, 'Lesson 1: Basic Greetings & Expressions', 'Learn common greetings and polite expressions for daily use.', 10, 1, '/static/images/lessons/4137/ffcb719d-cb7a-48a0-9cd0-b5b6481f7eb4.png', 'active', '2025-04-20 14:13:59', '2025-05-06 23:17:53', 0),
(4138, 9, 'Lesson 2: Introducing Yourself & Asking Questions', 'Say your name, introduce yourself, and ask for someone\'s name.', 10, 2, '/static/images/lessons/4138/1c01dd74-fbeb-4ade-881f-417734ce47ee.png', 'active', '2025-04-20 14:14:33', '2025-05-06 23:18:07', 0),
(4139, 8, 'Lesson 3: The Alphabet (N-Z)', 'Learn the second half of the alphabet from N to Z.', 10, 3, '/static/images/lessons/4139/9533a0d3-62f2-4447-888f-13a489030ce5.png', 'active', '2025-04-20 16:00:44', '2025-05-06 23:17:10', 0),
(4140, 8, 'Lesson 1: Introduction', 'Learn frequently used words in daily conversations related to communication and learning.', 10, 1, '', 'active', '2025-04-21 02:40:03', '2025-05-06 23:14:41', 1),
(4141, 8, 'Lesson 4', '', 0, 0, NULL, 'active', '2025-04-21 11:35:02', '2025-04-21 11:35:06', 1),
(4142, 9, 'Lesson 3: Family & People', 'Identify family members and common people-related words.', 10, 3, '/static/images/lessons/4142/3f8ca0d9-5e57-4680-94f9-53fa2ff1585d.png', 'active', '2025-04-21 11:55:17', '2025-05-06 23:18:35', 0),
(4143, 8, 'Lesson 4: Numbers (0-10)', 'Recognize and use the first set of numbers in sign language.', 10, 4, '/static/images/lessons/4143/1c0687b8-d61c-4803-9c36-fc7ff0137034.png', 'active', '2025-05-06 17:14:05', '2025-05-06 23:17:17', 0),
(4144, 8, 'Lesson 5: Numbers (10s - 100)', 'Learn how to sign multiples of 10 up to 100.', 10, 5, '/static/images/lessons/4144/89080567-933a-48bd-9bb0-04ab2dedb5c4.png', 'active', '2025-05-06 17:14:52', '2025-05-06 23:17:27', 0),
(4145, 8, 'Lesson 6: Telling Time', 'Learn how to sign time-related words and phrases.', 10, 6, '/static/images/lessons/4145/3899c39b-e8b8-4057-9dd7-acff5a53be31.png', 'active', '2025-05-06 17:15:19', '2025-05-06 23:17:41', 0),
(4146, 9, 'Lesson 4: Forming Simple Sentences', 'Learn how to structure simple sentences using learned vocabulary.', 10, 4, '/static/images/lessons/4146/5357032e-74f3-4db8-9971-826b5129661b.png', 'active', '2025-05-06 17:20:19', '2025-05-06 23:18:45', 0),
(4147, 10, 'Lesson 1: Daily Routine', 'Learn common daily activities and routine-related words.', 10, 1, '/static/images/lessons/4147/bc4aefa1-6b6c-401b-974c-0c83de3f02f0.png', 'active', '2025-05-06 17:21:01', '2025-05-06 23:18:51', 0),
(4148, 10, 'Lesson 2: Common Actions', 'Learn verbs related to daily activities.', 10, 2, '/static/images/lessons/4148/cc7f93b0-e8cd-4785-9a81-73f45f8e3b38.png', 'active', '2025-05-06 17:21:36', '2025-05-06 23:19:07', 0),
(4149, 10, 'Lesson 3: Expressing Needs & Wants', 'Learn how to express needs and wants.', 10, 3, '/static/images/lessons/4149/57c421ac-bd89-421e-877a-1568123cd869.png', 'active', '2025-05-06 17:22:18', '2025-05-06 23:19:16', 0),
(4150, 11, 'Lesson 1: Disasters and Calamities', 'Learn the signs for different disasters.', 10, 1, '/static/images/lessons/4150/d4e28aab-4925-48fa-ae26-a1c1fad47ad6.png', 'active', '2025-05-06 17:22:55', '2025-05-06 23:19:24', 0),
(4151, 11, 'Lesson 2: Crimes and Calling for Help', 'Learn how to ask for help in dangerous situations.', 10, 2, '/static/images/lessons/4151/bf0a8120-22df-418b-a2a5-33bb1157b6f8.png', 'active', '2025-05-06 17:23:28', '2025-05-06 23:19:32', 0),
(4152, 11, 'Lesson 3: Emergency Equipment', 'Recognize important emergency tools and learn their signs.', 10, 3, '/static/images/lessons/4152/34b21f06-94c1-4cb7-835e-08d1a03b566b.png', 'active', '2025-05-06 17:23:53', '2025-05-06 23:19:41', 0),
(4153, 11, 'Lesson 4: Commands and Warnings in Emergencies', 'Learn how to give commands during an emergency.', 10, 4, '/static/images/lessons/4153/6daebbb7-7d87-4f70-b6c9-c1f1c4e1d619.png', 'active', '2025-05-06 17:24:25', '2025-05-06 23:19:48', 0),
(4154, 11, 'Lesson 5: Emergency Actions', 'Learn the proper actions for different emergency situations.', 10, 5, '/static/images/lessons/4154/e7a526a8-9bc6-4b1b-a749-2c6832792f7c.png', 'active', '2025-05-06 17:24:51', '2025-05-06 23:19:58', 0),
(4155, 8, 'Lesson 1: Introduction', 'Learn frequently used words in daily conversation related to communication.', 10, 1, '/static/images/lessons/4155/36e740df-daed-452e-84be-4b19034d76d3.png', 'active', '2025-05-06 23:16:43', '2025-05-06 23:16:53', 0),
(4156, 12, 'Test', 'Test Lesson', 10, 1, '/static/images/lessons/4156/ae9de1cc-ab21-493e-86b2-1138d3064d6e.jpg', 'active', '2025-05-07 00:56:54', '2025-05-07 00:57:03', 0);

-- --------------------------------------------------------

--
-- Table structure for table `practice_games`
--

CREATE TABLE `practice_games` (
  `id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `game_identifier` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `practice_games`
--

INSERT INTO `practice_games` (`id`, `level_id`, `game_identifier`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 10, 'matching', 'Matching Game', 'Match signs with their meanings', '2025-04-21 03:55:11', '2025-04-21 03:55:11'),
(2, 10, 'identification', 'Sign Identification', 'Identify the correct meaning for each sign', '2025-04-21 03:55:11', '2025-04-21 03:55:11'),
(3, 11, 'speed', 'Speed Challenge', 'Identify signs as quickly as possible', '2025-04-21 03:55:11', '2025-04-21 03:55:11'),
(4, 11, 'sequence', 'Sequence Memory', 'Remember and reproduce sequences of signs', '2025-04-21 03:55:11', '2025-04-21 03:55:11'),
(5, 12, 'advanced-matching', 'Advanced Matching', 'Match multiple signs in context', '2025-04-21 03:55:11', '2025-04-21 03:55:11'),
(6, 12, 'sentence', 'Sentence Building', 'Build complete sentences using signs', '2025-04-21 03:55:11', '2025-04-21 03:55:11');

-- --------------------------------------------------------

--
-- Table structure for table `practice_levels`
--

CREATE TABLE `practice_levels` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `required_progress` int(11) DEFAULT NULL,
  `order_index` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `practice_levels`
--

INSERT INTO `practice_levels` (`id`, `name`, `description`, `required_progress`, `order_index`, `created_at`, `updated_at`) VALUES
(10, 'Beginner', 'Learn basic sign language gestures', 0, 0, '2025-04-21 03:47:59', '2025-04-21 03:47:59'),
(11, 'Intermediate', 'Practice common phrases and expressions', 30, 1, '2025-04-21 03:47:59', '2025-04-21 03:47:59'),
(12, 'Advanced', 'Master complex conversations and storytelling', 50, 2, '2025-04-21 03:47:59', '2025-04-21 03:47:59');

-- --------------------------------------------------------

--
-- Table structure for table `signs`
--

CREATE TABLE `signs` (
  `id` int(11) NOT NULL,
  `text` varchar(255) NOT NULL,
  `video_url` varchar(512) NOT NULL,
  `difficulty_level` enum('beginner','intermediate','advanced') DEFAULT 'beginner',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `archived` tinyint(1) DEFAULT 0,
  `lesson_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `signs`
--

INSERT INTO `signs` (`id`, `text`, `video_url`, `difficulty_level`, `created_at`, `archived`, `lesson_id`) VALUES
(49, 'Me', 'https://senya-video-server.senya-videos.workers.dev/7e5be4a7-0a0f-4e7a-ba73-1d27f0bdb2dc.mp4', 'beginner', '2025-05-06 17:28:45', 1, 4140),
(50, 'You', 'https://senya-video-server.senya-videos.workers.dev/b93d5ca5-e715-4be4-83ce-5cedc5ecff2e.mp4', 'beginner', '2025-05-06 17:29:06', 1, 4140),
(51, 'A', 'https://senya-video-server.senya-videos.workers.dev/ecf54e15-0047-4a4d-a892-17e72a461388.mp4', 'beginner', '2025-05-06 17:29:47', 0, 4135),
(52, 'B', 'https://senya-video-server.senya-videos.workers.dev/2b19b32d-9492-4813-8640-efbef8a71bab.mp4', 'beginner', '2025-05-06 17:30:06', 0, 4135),
(53, 'C', 'https://senya-video-server.senya-videos.workers.dev/75545de4-2016-4ff3-a290-151da58ae5dd.mp4', 'beginner', '2025-05-06 17:30:22', 0, 4135),
(54, 'Deaf', 'https://senya-video-server.senya-videos.workers.dev/a9905f51-ce46-4617-83e7-390ae6f70177.mp4', 'beginner', '2025-05-06 23:33:15', 0, 4155),
(55, 'Hearing', 'https://senya-video-server.senya-videos.workers.dev/359f729a-e7f3-4eec-8cb2-bb2767e05793.mp4', 'beginner', '2025-05-06 23:33:34', 0, 4155),
(56, 'Hello', 'https://senya-video-server.senya-videos.workers.dev/6a573b80-52ed-4f38-a9f0-dbdb98c5e797.mp4', 'beginner', '2025-05-06 23:33:52', 0, 4155),
(57, 'Welcome', 'https://senya-video-server.senya-videos.workers.dev/ddcdbf99-5247-4e59-a5be-655b9dd3f690.mp4', 'beginner', '2025-05-06 23:34:07', 0, 4155),
(58, 'Yes', 'https://senya-video-server.senya-videos.workers.dev/77527288-b77d-4046-a803-9189590c5c04.mp4', 'beginner', '2025-05-06 23:34:29', 0, 4155),
(59, 'No', 'https://senya-video-server.senya-videos.workers.dev/0814b293-8fee-45ae-9442-5f28489b8b90.mp4', 'beginner', '2025-05-06 23:34:58', 0, 4155),
(60, 'How', 'https://senya-video-server.senya-videos.workers.dev/6f81ada1-93fb-44ab-9896-b05ad3f51349.mp4', 'beginner', '2025-05-06 23:35:24', 0, 4155),
(61, 'Fine', 'https://senya-video-server.senya-videos.workers.dev/3dde9f3c-c7ad-496d-8ca6-26475d5e18c8.mp4', 'beginner', '2025-05-06 23:35:41', 0, 4155),
(62, 'Me', 'https://senya-video-server.senya-videos.workers.dev/99e9465c-81ea-4140-9113-84f64827c8e5.mp4', 'beginner', '2025-05-06 23:36:00', 0, 4155),
(63, 'You', 'https://senya-video-server.senya-videos.workers.dev/8e16e2f7-08de-4919-a9ca-1747d19ee47d.mp4', 'beginner', '2025-05-06 23:36:21', 0, 4155),
(64, 'D', 'https://senya-video-server.senya-videos.workers.dev/42ef1004-4ad5-404c-bd8d-5318f30a6428.mp4', 'beginner', '2025-05-07 00:57:59', 0, 4135),
(65, 'E', 'https://senya-video-server.senya-videos.workers.dev/3dd51a23-5134-4269-a840-3f73628f0f3b.mp4', 'beginner', '2025-05-08 06:40:01', 0, 4135),
(66, 'F', 'https://senya-video-server.senya-videos.workers.dev/3ad84d1d-1220-4242-bff8-92864f202015.mp4', 'beginner', '2025-05-08 06:40:24', 0, 4135),
(67, 'G', 'https://senya-video-server.senya-videos.workers.dev/5590a051-b1e5-4ed5-96a1-f74c15a84681.mp4', 'beginner', '2025-05-08 06:40:44', 0, 4135),
(68, 'H', 'https://senya-video-server.senya-videos.workers.dev/70924612-ca9c-43c1-8eef-dc16e5528a29.mp4', 'beginner', '2025-05-08 06:41:22', 0, 4135),
(69, 'I', 'https://senya-video-server.senya-videos.workers.dev/df283f0c-faa4-4c5d-a2e6-66c1eedea826.mp4', 'beginner', '2025-05-08 06:41:48', 0, 4135),
(70, 'J', 'https://senya-video-server.senya-videos.workers.dev/2c7c7d51-5b94-4671-8e7f-660bf96b6415.mp4', 'beginner', '2025-05-08 06:42:13', 0, 4135),
(71, 'K', 'https://senya-video-server.senya-videos.workers.dev/09836464-5606-466b-bf7d-736c0b2dca04.mp4', 'beginner', '2025-05-08 06:42:34', 0, 4135),
(72, 'L', 'https://senya-video-server.senya-videos.workers.dev/4d805704-d6b8-42fe-bed9-63b45d227785.mp4', 'beginner', '2025-05-08 06:43:05', 0, 4135),
(73, 'M', 'https://senya-video-server.senya-videos.workers.dev/3f9ed5c2-4f72-4b7b-ab6a-68b3e562b065.mp4', 'beginner', '2025-05-08 06:43:30', 0, 4135),
(74, 'N', 'https://senya-video-server.senya-videos.workers.dev/33a7b648-0628-429e-b32c-1b9b9601e4f9.mp4', 'beginner', '2025-05-08 06:44:17', 0, 4139),
(75, 'O', 'https://senya-video-server.senya-videos.workers.dev/9f271bc9-03ca-42be-a3b4-0a8e5739fb73.mp4', 'beginner', '2025-05-08 06:44:37', 0, 4139),
(76, 'P', 'https://senya-video-server.senya-videos.workers.dev/f7a4d231-0e46-4336-8e1a-135fbfb0b912.mp4', 'beginner', '2025-05-08 06:44:57', 0, 4139),
(77, 'Q', 'https://senya-video-server.senya-videos.workers.dev/b821cc50-71e8-4d23-9a28-680869b402e6.mp4', 'beginner', '2025-05-08 06:45:20', 0, 4139),
(78, 'R', 'https://senya-video-server.senya-videos.workers.dev/bcc64157-dfbb-4b8a-a5b1-8551580c77f0.mp4', 'beginner', '2025-05-08 06:45:44', 0, 4139),
(79, 'S', 'https://senya-video-server.senya-videos.workers.dev/10bdb399-a935-4fb3-8b90-9d0b1d8b7fc8.mp4', 'beginner', '2025-05-08 06:46:22', 0, 4139),
(80, 'T', 'https://senya-video-server.senya-videos.workers.dev/49597ebc-dff4-4dad-8366-9e2d0cc03b97.mp4', 'beginner', '2025-05-08 06:46:50', 0, 4139),
(81, 'U', 'https://senya-video-server.senya-videos.workers.dev/db01a205-7580-41f8-8541-a12552f3a2c8.mp4', 'beginner', '2025-05-08 06:48:35', 0, 4139),
(82, 'V', 'https://senya-video-server.senya-videos.workers.dev/0a1ef94f-7b13-4ad3-96bd-01fb8b3a47c8.mp4', 'beginner', '2025-05-08 06:49:17', 0, 4139),
(83, 'W', 'https://senya-video-server.senya-videos.workers.dev/1809cc42-34be-44f3-8d7a-2aab9912ae40.mp4', 'beginner', '2025-05-08 06:49:39', 0, 4139),
(84, 'X', 'https://senya-video-server.senya-videos.workers.dev/e1e66527-3052-4019-90da-80d92cb53961.mp4', 'beginner', '2025-05-08 06:50:12', 0, 4139),
(85, 'Y', 'https://senya-video-server.senya-videos.workers.dev/589e91bb-d3e8-4b79-ae53-baa57d135d29.mp4', 'beginner', '2025-05-08 06:51:30', 0, 4139),
(86, 'Z', 'https://senya-video-server.senya-videos.workers.dev/685019f5-39c5-4977-bebc-eb0a247e3bd3.mp4', 'beginner', '2025-05-08 06:51:57', 0, 4139),
(87, '1', 'https://senya-video-server.senya-videos.workers.dev/99453410-bd23-43db-a44e-091c9e6da1ca.mp4', 'beginner', '2025-05-08 06:52:43', 0, 4143),
(88, '2', 'https://senya-video-server.senya-videos.workers.dev/43dbc941-c6cb-4bb9-adf6-5c7410587614.mp4', 'beginner', '2025-05-08 06:53:10', 0, 4143),
(89, '3', 'https://senya-video-server.senya-videos.workers.dev/c6cce1a7-d75a-4e5c-9162-4beb56f4c52b.mp4', 'beginner', '2025-05-08 06:53:34', 0, 4143),
(90, '4', 'https://senya-video-server.senya-videos.workers.dev/3895faaa-f4fe-45f2-b2c8-4c4fb79f8220.mp4', 'beginner', '2025-05-08 06:53:57', 0, 4143),
(91, '5', 'https://senya-video-server.senya-videos.workers.dev/1939fc0d-e51a-42d5-951d-fa25181fb51a.mp4', 'beginner', '2025-05-08 06:54:24', 0, 4143),
(92, '6', 'https://senya-video-server.senya-videos.workers.dev/63489a86-acee-4a05-baf8-10e2933a042a.mp4', 'beginner', '2025-05-08 06:54:59', 0, 4143),
(93, '7', 'https://senya-video-server.senya-videos.workers.dev/8709ee50-1d84-4809-a559-f3bb6b689e1a.mp4', 'beginner', '2025-05-08 06:55:22', 0, 4143),
(94, '8', 'https://senya-video-server.senya-videos.workers.dev/38deceb9-5937-4818-b42f-2211a030dfce.mp4', 'beginner', '2025-05-08 06:55:48', 0, 4143),
(95, '9', 'https://senya-video-server.senya-videos.workers.dev/ef415030-debc-486e-9193-7c043aac0295.mp4', 'beginner', '2025-05-08 06:56:17', 0, 4143),
(96, '10', 'https://senya-video-server.senya-videos.workers.dev/1fe61592-de16-4073-b8e3-abd0432eca53.mp4', 'beginner', '2025-05-08 06:56:42', 0, 4143),
(97, '10', 'https://senya-video-server.senya-videos.workers.dev/e09f39fa-af24-4c2c-b1f5-4a212ca40449.mp4', 'beginner', '2025-05-08 06:57:10', 0, 4144),
(98, '20', 'https://senya-video-server.senya-videos.workers.dev/4cdd4615-fa33-4207-819e-ce467f20549f.mp4', 'beginner', '2025-05-08 06:57:37', 0, 4144),
(99, '30', 'https://senya-video-server.senya-videos.workers.dev/fb3d28ee-5f23-4a25-81ba-c5970c33f4f0.mp4', 'beginner', '2025-05-08 06:57:54', 0, 4144),
(100, '40', 'https://senya-video-server.senya-videos.workers.dev/d36d79a5-d7aa-49e0-b56b-e3206ba28b2a.mp4', 'beginner', '2025-05-08 06:58:27', 0, 4144),
(101, '50', 'https://senya-video-server.senya-videos.workers.dev/f8d4a361-85e9-4cdd-afa0-ad37718b64f7.mp4', 'beginner', '2025-05-08 06:58:57', 0, 4144),
(102, '60', 'https://senya-video-server.senya-videos.workers.dev/f5c294ae-2237-4491-89c4-a0e1c2bdb14c.mp4', 'beginner', '2025-05-08 06:59:23', 0, 4144),
(103, '70', 'https://senya-video-server.senya-videos.workers.dev/ea02cb4d-d7c4-418a-a5d6-50e56a0667d1.mp4', 'beginner', '2025-05-08 06:59:42', 0, 4144),
(104, '80', 'https://senya-video-server.senya-videos.workers.dev/b4bb0154-355c-4e94-a4f5-32df26cff345.mp4', 'beginner', '2025-05-08 07:00:01', 0, 4144),
(105, '90', 'https://senya-video-server.senya-videos.workers.dev/b643ff29-bd4d-4b4a-8121-58cc38885999.mp4', 'beginner', '2025-05-08 07:00:23', 0, 4144),
(106, '100', 'https://senya-video-server.senya-videos.workers.dev/bef8ddfd-4771-4da4-b35c-57e79a23f49d.mp4', 'beginner', '2025-05-08 07:00:44', 0, 4144),
(107, 'Time', 'https://senya-video-server.senya-videos.workers.dev/ededbb17-2f78-4f58-8c10-fca32e8c82f5.mp4', 'beginner', '2025-05-08 07:05:15', 0, 4145),
(108, 'Hour', 'https://senya-video-server.senya-videos.workers.dev/22c3b802-fc89-40f7-9ed3-1aadeff78c97.mp4', 'beginner', '2025-05-08 07:05:47', 0, 4145),
(109, 'Minute', 'https://senya-video-server.senya-videos.workers.dev/c8eee3d8-62a6-4578-a65b-aa3d0c63dafe.mp4', 'beginner', '2025-05-08 07:06:10', 0, 4145),
(110, 'Second', 'https://senya-video-server.senya-videos.workers.dev/a82a2620-a30a-4d37-833c-fa7c0b24b746.mp4', 'beginner', '2025-05-08 07:06:35', 0, 4145),
(111, 'Morning', 'https://senya-video-server.senya-videos.workers.dev/8b40e56c-e446-4208-8574-7c7cf5954af0.mp4', 'beginner', '2025-05-08 07:28:59', 0, 4145),
(112, 'Afternoon', 'https://senya-video-server.senya-videos.workers.dev/76e9f5ac-79ef-46d7-97eb-e5893377068f.mp4', 'beginner', '2025-05-08 07:29:36', 0, 4145),
(113, 'Evening', 'https://senya-video-server.senya-videos.workers.dev/d6694f7e-0496-4392-a23e-d8eb5d5de7c9.mp4', 'beginner', '2025-05-08 07:30:04', 0, 4145),
(114, 'Later', 'https://senya-video-server.senya-videos.workers.dev/6e44c033-240a-48db-9334-f3adaee5fe2d.mp4', 'beginner', '2025-05-08 07:30:42', 0, 4145),
(115, 'Now', 'https://senya-video-server.senya-videos.workers.dev/6cfd6288-d0d3-4363-a609-56a48227029c.mp4', 'beginner', '2025-05-08 07:31:08', 0, 4145),
(116, 'Soon', 'https://senya-video-server.senya-videos.workers.dev/cb54ee1c-657f-4275-bb05-cfcae4a8bc48.mp4', 'beginner', '2025-05-08 07:31:37', 0, 4145),
(117, 'What time is it now?', 'https://senya-video-server.senya-videos.workers.dev/5dc87b89-7a31-4e1d-8664-9e88ad01e49e.mp4', 'intermediate', '2025-05-08 07:33:00', 1, 4145),
(118, 'What is the time?', 'https://senya-video-server.senya-videos.workers.dev/16c26851-6d46-455f-b953-aece9231b1c1.mp4', 'intermediate', '2025-05-08 07:33:52', 0, 4145),
(119, 'I am fine, Thank you', 'https://senya-video-server.senya-videos.workers.dev/de28eec3-979f-4132-90f1-754e7cb094b7.mp4', 'intermediate', '2025-05-08 07:35:38', 0, 4155),
(120, 'Hello, How are you?', 'https://senya-video-server.senya-videos.workers.dev/66d3a40b-da3f-44d0-94b1-6db1b5861120.mp4', 'intermediate', '2025-05-08 07:36:32', 0, 4155);

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE `units` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `order_index` int(11) DEFAULT 0,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archived` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `units`
--

INSERT INTO `units` (`id`, `title`, `description`, `order_index`, `status`, `created_at`, `updated_at`, `archived`) VALUES
(8, 'Unit 1: The Basics', '', 1, 'active', '2025-04-20 14:04:24', '2025-04-20 14:04:24', 0),
(9, 'Unit 2: Daily Greetings & Expressions', '', 2, 'active', '2025-04-20 14:12:59', '2025-04-20 14:12:59', 0),
(10, 'Unit 3: Daily Activities & Routine', '', 3, 'active', '2025-04-21 11:55:00', '2025-05-06 17:07:52', 0),
(11, 'Unit 4: Emergency Signs', '', 4, 'active', '2025-05-06 17:08:56', '2025-05-06 17:08:56', 0),
(12, 'Unit 5: Final Assessment', '', 5, 'active', '2025-05-06 17:09:18', '2025-05-06 17:09:18', 0),
(13, 'Test1', '', 6, 'active', '2025-05-07 00:55:54', '2025-05-07 00:56:06', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `profile_url` varchar(512) DEFAULT NULL,
  `progress` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`progress`)),
  `rubies` int(11) DEFAULT 0,
  `hearts` int(11) DEFAULT 5,
  `streak` int(11) DEFAULT 0,
  `certificate` tinyint(1) DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `hearts_last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_lesson_date` timestamp NULL DEFAULT NULL,
  `streak_updated_today` tinyint(1) DEFAULT 0,
  `last_challenge_date` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `profile_url`, `progress`, `rubies`, `hearts`, `streak`, `certificate`, `updated_at`, `hearts_last_updated`, `last_lesson_date`, `streak_updated_today`, `last_challenge_date`) VALUES
(7, '/static/images/profiles/7/d9b0c14a-cb8b-4cdb-b2cc-2b3e8b2dc1be.png', '{}', 80, 5, 3, 1, '2025-04-22 15:38:24', '2025-04-22 07:38:23', '2025-04-21 04:09:42', 0, '2025-04-22 00:37:06'),
(8, NULL, '{}', 15, 5, 0, 0, '2025-04-22 10:09:26', '2025-04-22 02:07:08', NULL, 0, NULL),
(9, NULL, '{}', 20, 0, 1, 0, '2025-04-14 04:19:28', '2025-04-14 03:33:33', '2025-04-13 20:19:01', 0, NULL),
(10, '/static/images/profiles/10/448bbbcf-cd55-43a3-a15f-6cc0ea305e68.png', '{}', 242, 3, 3, 1, '2025-04-22 11:38:52', '2025-04-22 03:34:32', '2025-04-21 19:54:26', 0, '2025-04-19 18:34:26'),
(11, NULL, '{}', 115, 4, 3, 1, '2025-04-23 03:28:23', '2025-04-22 19:24:04', '2025-04-22 19:27:44', 0, '2025-04-22 19:27:52'),
(12, NULL, '{}', 70, 4, 1, 0, '2025-04-22 09:54:01', '2025-04-22 09:28:44', '2025-04-22 01:53:31', 0, '2025-04-22 01:54:01'),
(13, NULL, '{}', 0, 5, 0, 0, '2025-05-06 11:53:09', '2025-05-06 11:53:09', NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_practice_progress`
--

CREATE TABLE `user_practice_progress` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `level_id` int(11) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `high_score` int(11) DEFAULT NULL,
  `progress` int(11) DEFAULT NULL,
  `completed` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp(),
  `attempt_count` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `user_practice_progress`
--

INSERT INTO `user_practice_progress` (`id`, `user_id`, `level_id`, `game_id`, `high_score`, `progress`, `completed`, `created_at`, `updated_at`, `attempt_count`) VALUES
(1, 7, 10, 1, 143, 100, 1, '2025-04-21 03:59:34', '2025-04-21 04:00:12', 1),
(2, 10, 10, 1, 144, 100, 1, '2025-04-21 04:11:32', '2025-04-21 04:11:32', 1),
(3, 10, 10, 2, 85, 85, 1, '2025-04-21 04:11:50', '2025-04-21 04:11:50', 1),
(4, 10, 12, 6, 148, 100, 1, '2025-04-21 06:28:14', '2025-04-21 09:47:57', 1),
(5, 10, 11, 4, 0, 0, 0, '2025-04-21 06:31:00', '2025-04-21 06:31:00', 1),
(6, 10, 11, 3, 184, 100, 1, '2025-04-21 06:32:51', '2025-04-21 08:31:08', 1),
(7, 10, 12, 5, 0, 0, 0, '2025-04-21 09:44:56', '2025-04-21 09:44:56', 1),
(8, 7, 10, 2, 61, 61, 0, '2025-04-21 11:12:20', '2025-04-21 15:36:45', 1),
(9, 7, 11, 3, 0, 0, 0, '2025-04-22 03:45:24', '2025-04-22 03:45:24', 1),
(10, 7, 11, 4, 0, 0, 0, '2025-04-22 03:45:27', '2025-04-22 03:45:27', 1),
(11, 11, 10, 2, 59, 59, 0, '2025-04-23 03:26:56', '2025-04-23 03:26:56', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_progress`
--

CREATE TABLE `user_progress` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `lesson_id` int(11) DEFAULT NULL,
  `progress` int(11) DEFAULT NULL,
  `completed` tinyint(1) DEFAULT NULL,
  `last_question` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp(),
  `time_spent` float DEFAULT NULL,
  `repeat` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `user_progress`
--

INSERT INTO `user_progress` (`id`, `user_id`, `lesson_id`, `progress`, `completed`, `last_question`, `updated_at`, `time_spent`, `repeat`) VALUES
(21, 10, 4133, 100, 1, 2, '2025-04-20 14:49:24', NULL, 0),
(22, 10, 4135, 100, 1, 2, '2025-04-20 15:03:38', NULL, 0),
(23, 7, 4135, 100, 1, 2, '2025-04-22 15:31:10', NULL, 0),
(24, 7, 4139, 100, 1, 2, '2025-04-21 12:11:21', NULL, 0),
(25, 7, 4137, 100, 1, 1, '2025-04-21 02:35:55', NULL, 0),
(26, 7, 4140, 83, 1, 1, '2025-04-22 15:32:57', NULL, 0),
(27, 10, 4140, 100, 1, 1, '2025-04-22 11:39:07', NULL, 0),
(28, 10, 4139, 100, 1, 2, '2025-04-21 06:27:53', NULL, 0),
(29, 10, 4137, 100, 1, 1, '2025-04-22 10:08:18', NULL, 0),
(30, 10, 4138, 100, 1, 1, '2025-04-22 03:54:09', NULL, 0),
(31, 7, 4138, 100, 1, 1, '2025-04-22 03:53:32', NULL, 0),
(32, 7, 4142, 67, 0, 0, '2025-04-21 13:17:42', NULL, 0),
(33, 11, 4140, 100, 1, 1, '2025-04-22 13:16:04', NULL, 0),
(34, 10, 4142, 100, 1, 0, '2025-04-22 03:54:26', NULL, 0),
(35, 11, 4135, 100, 1, 2, '2025-04-22 08:03:29', NULL, 0),
(36, 11, 4139, 100, 1, 2, '2025-04-22 08:03:55', NULL, 0),
(37, 11, 4138, 100, 1, 1, '2025-04-22 10:16:25', NULL, 0),
(38, 12, 4140, 100, 1, 1, '2025-04-22 09:45:23', NULL, 0),
(39, 12, 4135, 100, 1, 2, '2025-04-22 09:53:04', NULL, 0),
(40, 12, 4139, 100, 1, 2, '2025-04-22 09:53:31', NULL, 0),
(41, 12, 4137, 17, 0, 0, '2025-04-22 10:04:05', NULL, 0),
(42, 11, 4137, 100, 1, 1, '2025-04-22 10:10:02', NULL, 0),
(43, 11, 4142, 100, 1, 0, '2025-04-23 03:27:44', NULL, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `username_2` (`username`);

--
-- Indexes for table `heart_packages`
--
ALTER TABLE `heart_packages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lessons`
--
ALTER TABLE `lessons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `unit_id` (`unit_id`);

--
-- Indexes for table `practice_games`
--
ALTER TABLE `practice_games`
  ADD PRIMARY KEY (`id`),
  ADD KEY `level_id` (`level_id`);

--
-- Indexes for table `practice_levels`
--
ALTER TABLE `practice_levels`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `signs`
--
ALTER TABLE `signs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `user_practice_progress`
--
ALTER TABLE `user_practice_progress`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `level_id` (`level_id`),
  ADD KEY `game_id` (`game_id`);

--
-- Indexes for table `user_progress`
--
ALTER TABLE `user_progress`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `lesson_id` (`lesson_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `heart_packages`
--
ALTER TABLE `heart_packages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `lessons`
--
ALTER TABLE `lessons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4157;

--
-- AUTO_INCREMENT for table `practice_games`
--
ALTER TABLE `practice_games`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `practice_levels`
--
ALTER TABLE `practice_levels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `signs`
--
ALTER TABLE `signs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT for table `units`
--
ALTER TABLE `units`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `user_practice_progress`
--
ALTER TABLE `user_practice_progress`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `user_progress`
--
ALTER TABLE `user_progress`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `lessons`
--
ALTER TABLE `lessons`
  ADD CONSTRAINT `lessons_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`);

--
-- Constraints for table `practice_games`
--
ALTER TABLE `practice_games`
  ADD CONSTRAINT `practice_games_ibfk_1` FOREIGN KEY (`level_id`) REFERENCES `practice_levels` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`user_id`);

--
-- Constraints for table `user_practice_progress`
--
ALTER TABLE `user_practice_progress`
  ADD CONSTRAINT `user_practice_progress_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`user_id`),
  ADD CONSTRAINT `user_practice_progress_ibfk_2` FOREIGN KEY (`level_id`) REFERENCES `practice_levels` (`id`),
  ADD CONSTRAINT `user_practice_progress_ibfk_3` FOREIGN KEY (`game_id`) REFERENCES `practice_games` (`id`);

--
-- Constraints for table `user_progress`
--
ALTER TABLE `user_progress`
  ADD CONSTRAINT `user_progress_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`user_id`),
  ADD CONSTRAINT `user_progress_ibfk_2` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
