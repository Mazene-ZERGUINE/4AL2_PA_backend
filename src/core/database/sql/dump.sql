--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)
-- Dumped by pg_dump version 16.2 (Debian 16.2-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: file_types_enum; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.file_types_enum AS ENUM (
    'txt',
    'csv',
    'json',
    'xlsx',
    'yml'
);


ALTER TYPE public.file_types_enum OWNER TO psql;

--
-- Name: program_visibility_enum; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.program_visibility_enum AS ENUM (
    'public',
    'private',
    'only_followers'
);


ALTER TYPE public.program_visibility_enum OWNER TO psql;

--
-- Name: programming_language_enum; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.programming_language_enum AS ENUM (
    'python',
    'javascript'
);


ALTER TYPE public.programming_language_enum OWNER TO psql;

--
-- Name: reaction_entity_type_enum; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.reaction_entity_type_enum AS ENUM (
    'like',
    'dislike'
);


ALTER TYPE public.reaction_entity_type_enum OWNER TO psql;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: comment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.comment (
    "commentId" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    content text NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "userId" uuid,
    "programId" uuid,
    "codeLineNumber" integer,
    "parentCommentId" uuid
);


ALTER TABLE public.comment OWNER TO psql;

--
-- Name: follow; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.follow (
    "relationId" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "followerUserId" uuid,
    "followingUserId" uuid
);


ALTER TABLE public.follow OWNER TO psql;

--
-- Name: group; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public."group" (
    "groupId" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(60) NOT NULL,
    description text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "ownerUserId" uuid NOT NULL,
    "imageUrl" text,
    visibility text DEFAULT 'public'::text
);


ALTER TABLE public."group" OWNER TO psql;

--
-- Name: group_programs; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.group_programs (
    "groupId" uuid NOT NULL,
    "programId" uuid NOT NULL
);


ALTER TABLE public.group_programs OWNER TO psql;

--
-- Name: program; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.program (
    "programId" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    description character varying(255),
    "programmingLanguage" character varying NOT NULL,
    "sourceCode" character varying NOT NULL,
    visibility character varying NOT NULL,
    "inputTypes" text,
    "outputTypes" text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "userUserId" uuid,
    "isProgramGroup" boolean DEFAULT false
);


ALTER TABLE public.program OWNER TO psql;

--
-- Name: program-version; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public."program-version" (
    "programVersionId" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    version character varying DEFAULT '1.0.0'::character varying NOT NULL,
    "programmingLanguage" character varying NOT NULL,
    "sourceCode" character varying NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "programProgramId" uuid
);


ALTER TABLE public."program-version" OWNER TO psql;

--
-- Name: program-versions; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public."program-versions" (
    "programVersionId" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    version character varying DEFAULT '1.0.0'::character varying NOT NULL,
    "programmingLanguage" character varying NOT NULL,
    "sourceCode" character varying NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "programProgramId" uuid
);


ALTER TABLE public."program-versions" OWNER TO psql;

--
-- Name: program_version_entity; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.program_version_entity (
    "programVersionId" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    version character varying DEFAULT '1.0.0'::character varying NOT NULL,
    "programmingLanguage" character varying NOT NULL,
    "sourceCode" character varying NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "programProgramId" uuid
);


ALTER TABLE public.program_version_entity OWNER TO psql;

--
-- Name: reaction_entity; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.reaction_entity (
    "reactionId" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    type public.reaction_entity_type_enum NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "userId" uuid,
    "programId" uuid
);


ALTER TABLE public.reaction_entity OWNER TO psql;

--
-- Name: user; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public."user" (
    "userId" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "userName" character varying(60) NOT NULL,
    "firstName" character varying(60) NOT NULL,
    "lastName" character varying(60) NOT NULL,
    email character varying(60) NOT NULL,
    password character varying(255) NOT NULL,
    "avatarUrl" character varying,
    bio character varying,
    "isVerified" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."user" OWNER TO psql;

--
-- Name: user_groups; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_groups (
    "userId" uuid NOT NULL,
    "groupId" uuid NOT NULL
);


ALTER TABLE public.user_groups OWNER TO psql;

--
-- Name: users; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.users (
    "userId" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "userName" character varying(60) NOT NULL,
    "firstName" character varying(60) NOT NULL,
    "lastName" character varying(60) NOT NULL,
    email character varying(60) NOT NULL,
    password character varying(255) NOT NULL,
    "avatarUrl" character varying,
    bio character varying,
    "isVerified" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO psql;

--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: psql
--

COPY public.comment ("commentId", content, "createdAt", "updatedAt", "userId", "programId", "codeLineNumber", "parentCommentId") FROM stdin;
\.


--
-- Data for Name: follow; Type: TABLE DATA; Schema: public; Owner: psql
--

COPY public.follow ("relationId", "followerUserId", "followingUserId") FROM stdin;
36d9cd8f-5d00-4cae-81fe-6eab4843c023	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	f927fc08-8f8a-4a0b-adec-d924091dcad1
\.


--
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: psql
--

COPY public."group" ("groupId", name, description, "createdAt", "updatedAt", "ownerUserId", "imageUrl", visibility) FROM stdin;
76de736c-3969-4979-8f1a-6a4afe6d8d7e	JS for images	a group dedicated for image transformations enthousiaste developpers to share their programmes in different programming languages as javscript / python / c++ and other languages join now 	2024-06-22 16:56:47.734838	2024-06-22 16:56:47.734838	9623ff85-67b1-4f4d-8b48-1544c3cb38ab	localhost:3000/uploads/avatars/8f88a9c4-d1fe-45d6-90e6-14e41e33b45e.jpg	private
b239d202-2b9d-44b5-9f94-a596fbcdf608	JS advanced group	all types of files transformation programmes in nodeJS	2024-06-22 17:08:26.900232	2024-06-22 17:08:26.900232	a9b20768-6469-4d39-b0aa-c4ed19ae9897	localhost:3000/uploads/avatars/d0fcac62-f48c-4322-aeb2-263e320f3380.png	private
9704c250-2c29-4f49-a5dc-c3fface6a852	frontendDev		2024-06-22 17:11:30.321864	2024-06-22 17:11:30.321864	b0ed894a-610d-498c-b11f-ed47d2a87b29	\N	public
f5bf0ba1-59b3-4ebf-8bf0-659482d81487	Node for backend	group for nodeJs developpers	2024-06-22 17:19:12.106356	2024-06-22 17:19:12.106356	b0ed894a-610d-498c-b11f-ed47d2a87b29	localhost:3000/uploads/avatars/ab7b4122-a537-4abe-8a64-003b6cf8c8aa.png	public
21de695d-1881-42e4-a55a-488e7b9803cb	i hate php		2024-06-22 17:33:05.099321	2024-06-22 17:33:05.099321	f8c6500d-bbf6-4c88-959c-c67c7e572fc0	localhost:3000/uploads/avatars/0fdaa2e9-a20b-45c3-9f63-4039927bdbe7.png	public
3d534968-0a02-4591-a212-9bcea2647345	Design patterns in C++		2024-06-22 17:35:34.164274	2024-06-22 17:35:34.164274	f8c6500d-bbf6-4c88-959c-c67c7e572fc0	localhost:3000/uploads/avatars/1e2b3248-3b3d-47e3-9ca7-b84488a97d24.jpg	private
a1ca570a-9fa9-499a-8976-d5a1623d5cd8	Cloud AWS		2024-06-22 17:40:41.521895	2024-06-22 17:40:41.521895	f927fc08-8f8a-4a0b-adec-d924091dcad1	localhost:3000/uploads/avatars/ff4355dd-6056-4bc8-9dc0-633951b23d71.png	private
72ccf4fa-a557-4a29-ad3b-a2bc1c822253	C++ (GOAT)	Only goats here 	2024-06-22 17:00:52.904667	2024-06-22 17:00:52.904667	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	localhost:3000/uploads/avatars/4f16780f-63ba-4b5a-b5c7-102a91499392.png	public
\.


--
-- Data for Name: group_programs; Type: TABLE DATA; Schema: public; Owner: psql
--

COPY public.group_programs ("groupId", "programId") FROM stdin;
72ccf4fa-a557-4a29-ad3b-a2bc1c822253	b94a2717-25d8-4468-86ef-ff848914d361
72ccf4fa-a557-4a29-ad3b-a2bc1c822253	f78c6ff8-c684-42cf-96e5-729f6eea2c2a
72ccf4fa-a557-4a29-ad3b-a2bc1c822253	20ff146f-bd26-4272-8dce-016480cf0455
\.


--
-- Data for Name: program; Type: TABLE DATA; Schema: public; Owner: psql
--

COPY public.program ("programId", description, "programmingLanguage", "sourceCode", visibility, "inputTypes", "outputTypes", "createdAt", "updatedAt", "userUserId", "isProgramGroup") FROM stdin;
88e39a98-56a3-4d25-936a-21dae870d0b3	JS code that takes images and create thumbnails 	javascript	const Jimp = require('jimp');\nconst fs = require('fs-extra');\nconst path = require('path');\n\nasync function createThumbnails(inputImagePaths, outputImagePaths, thumbnailSize = 100) {\n  for (let i = 0; i < inputImagePaths.length; i++) {\n    const inputFilePath = inputImagePaths[i];\n    const outputFilePath = outputImagePaths[i];\n    const image = await Jimp.read(inputFilePath);\n    const thumbnail = image.resize(thumbnailSize, Jimp.AUTO);\n    await thumbnail.writeAsync(outputFilePath);\n  }\n\n  console.log('Thumbnails have been created for the images.');\n}\n\nconst inputImagePaths = [INPUT_FILE_PATH_0, INPUT_FILE_PATH_1]; // Replace with your input image file paths\nconst outputImagePaths = [OUTPUT_FILE_PATH_0, OUTPUT_FILE_PATH_0]; // Replace with your output thumbnail file paths\n\ncreateThumbnails(inputImagePaths, outputImagePaths);\n	public	png	png	2024-06-21 21:45:49.043283	2024-06-21 21:45:49.043283	6a766343-b2eb-491f-8abb-ac90dd69fa95	f
327c8fef-d34c-45e8-aec2-0d226e8347ad	generating reports from json and yaml files 	javascript	const fs = require('fs-extra');\nconst yaml = require('yaml');\nconst path = require('path');\n\nasync function processFilesAndGenerateReports(inputJsonPaths, inputYamlPaths, outputJsonPath, outputYamlPath) {\n  const summary = { jsonFiles: [], yamlFiles: [] };\n\n  for (const filePath of inputJsonPaths) {\n    const data = await fs.readJson(filePath);\n    summary.jsonFiles.push({ file: path.basename(filePath), data });\n  }\n\n  for (const filePath of inputYamlPaths) {\n    const data = yaml.parse(await fs.readFile(filePath, 'utf8'));\n    summary.yamlFiles.push({ file: path.basename(filePath), data });\n  }\n\n  await fs.writeJson(outputJsonPath, summary, { spaces: 2 });\n  await fs.writeFile(outputYamlPath, yaml.stringify(summary));\n  console.log('Reports have been generated in JSON and YAML formats.');\n}\n\nconst inputJsonPaths = [INPUT_FILE_PATH_0, INPUT_FILE_PATH_1]; \nconst inputYamlPaths = [INPUT_FILE_PATH_2, INPUT_FILE_PATH_3]; \nconst outputJsonPath = OUTPUT_FILE_PATH_0;\nconst outputYamlPath = OUTPUT_FILE_PATH_1; \n\nprocessFilesAndGenerateReports(inputJsonPaths, inputYamlPaths, outputJsonPath, outputYamlPath);\n	public	json	yml	2024-06-21 21:51:47.029329	2024-06-21 21:51:47.029329	6a766343-b2eb-491f-8abb-ac90dd69fa95	f
20ff146f-bd26-4272-8dce-016480cf0455	a c++ program that reads txt file of this format (John Doe, johndoe@example.com, 30) and gnerate a json file with data	c++	#include <iostream>\n#include <fstream>\n#include <sstream>\n#include <vector>\n#include <string>\n\n// Structure to hold user data\nstruct User\n{\n    std::string name;\n    std::string email;\n    int age;\n};\n\n// Function to read users from a text file\nstd::vector<User> readUsersFromFile(const std::string &filename)\n{\n    std::vector<User> users;\n    std::ifstream infile(filename);\n    std::string line;\n\n    while (std::getline(infile, line))\n    {\n        std::istringstream iss(line);\n        std::string name, email, ageStr;\n        if (std::getline(iss, name, ',') &&\n            std::getline(iss, email, ',') &&\n            std::getline(iss, ageStr))\n        {\n            User user;\n            user.name = name;\n            user.email = email;\n            user.age = std::stoi(ageStr);\n            users.push_back(user);\n        }\n    }\n\n    return users;\n}\n\n// Function to write users to a JSON file\nvoid writeUsersToJson(const std::string &filename, const std::vector<User> &users)\n{\n    std::ofstream outfile(filename);\n    outfile << "[\\n";\n    for (size_t i = 0; i < users.size(); ++i)\n    {\n        outfile << "  {\\n";\n        outfile << "    \\"name\\": \\"" << users[i].name << "\\",\\n";\n        outfile << "    \\"email\\": \\"" << users[i].email << "\\",\\n";\n        outfile << "    \\"age\\": " << users[i].age << "\\n";\n        outfile << "  }";\n        if (i < users.size() - 1)\n        {\n            outfile << ",";\n        }\n        outfile << "\\n";\n    }\n    outfile << "]";\n}\n\nint main()\n{\n    std::string inputFilename = INPUT_FILE_PATH_0;\n    std::string outputFilename = OUTPUT_FILE_PATH_0;\n\n    // Read users from the text file\n    std::vector<User> users = readUsersFromFile(inputFilename);\n\n    // Write users to the JSON file\n    writeUsersToJson(outputFilename, users);\n\n    std::cout << "User data has been written to " << outputFilename << std::endl;\n\n    return 0;\n}\n	private	txt	json	2024-06-22 18:56:43.37739	2024-06-22 18:56:43.37739	f927fc08-8f8a-4a0b-adec-d924091dcad1	t
e0ecda2a-7159-4e41-bff6-53a6e34060a8	this is an example of a python code that reads the contents of json/yml/ and png image and writtes it in a pdf file	python	import yaml\nimport json\nfrom pathlib import Path\nfrom reportlab.lib.pagesizes import letter\nfrom reportlab.pdfgen import canvas\nfrom PIL import Image\n\n# File paths\nyaml_file = INPUT_FILE_PATH_0\njson_file = INPUT_FILE_PATH_1\npng_file = Path(INPUT_FILE_PATH_2)\npdf_file = Path(OUTPUT_FILE_PATH_0)\n\n# Read YAML file\nwith open(yaml_file, 'r') as file:\n    user_details = yaml.safe_load(file)\n\n# Read JSON file\nwith open(json_file, 'r') as file:\n    articles = json.load(file)\n\n# Create PDF\nc = canvas.Canvas(str(pdf_file), pagesize=letter)\nwidth, height = letter\n\n# User details\nc.setFont("Helvetica", 12)\ny = height - 40\nfor key, value in user_details.items():\n    c.drawString(40, y, f"{key}: {value}")\n    y -= 20\n\n# Articles\nc.drawString(40, y - 20, "Articles:")\ny -= 40\nfor article in articles:\n    c.drawString(60, y, f"Title: {article['title']}")\n    y -= 20\n    c.drawString(80, y, f"Content: {article['content']}")\n    y -= 40\n\n# Add PNG image\nimage = Image.open(png_file)\nimage_width, image_height = image.size\nimage_ratio = image_height / image_width\nc.drawImage(png_file, 40, 40, width - 80, (width - 80) * image_ratio)\n\nc.save()\n\nprint("PDF created successfully.")\n	public	json,yml,png	pdf	2024-06-21 18:45:29.694812	2024-06-21 18:45:29.694812	57d296e1-7af7-4cfc-afd2-7bc6352a65e6	f
bb155671-05c6-46cd-a043-72547a413430	hello word JS code	javascript	function hello() {\n  console.log("Hello, world!");\n}\n\nhello();	public			2024-06-21 18:56:52.331978	2024-06-21 18:56:52.331978	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	f
b85d1b4b-f01d-41f8-b273-ac2816c566b5	c++ code that takes a file of numbers and test the performance of differnt sort algorithmes (no output)	c++	#include <iostream>\n#include <vector>\n#include <fstream>\n#include <chrono>\n#include <algorithm>\n\n// Function to read numbers from a file\nstd::vector<int> readNumbersFromFile(const std::string& filename) {\n    std::vector<int> numbers;\n    std::ifstream inputFile(filename);\n    if (!inputFile) {\n        std::cerr << "Error opening file: " << filename << std::endl;\n        return numbers;\n    }\n\n    int number;\n    while (inputFile >> number) {\n        numbers.push_back(number);\n    }\n\n    inputFile.close();\n    return numbers;\n}\n\n// Bubble Sort\nvoid bubbleSort(std::vector<int>& arr) {\n    int n = arr.size();\n    for (int i = 0; i < n - 1; ++i) {\n        for (int j = 0; j < n - 1 - i; ++j) {\n            if (arr[j] > arr[j + 1]) {\n                std::swap(arr[j], arr[j + 1]);\n            }\n        }\n    }\n}\n\n// Insertion Sort\nvoid insertionSort(std::vector<int>& arr) {\n    int n = arr.size();\n    for (int i = 1; i < n; ++i) {\n        int key = arr[i];\n        int j = i - 1;\n        while (j >= 0 && arr[j] > key) {\n            arr[j + 1] = arr[j];\n            --j;\n        }\n        arr[j + 1] = key;\n    }\n}\n\n// Partition function for Quick Sort\nint partition(std::vector<int>& arr, int low, int high) {\n    int pivot = arr[high];\n    int i = low - 1;\n    for (int j = low; j < high; ++j) {\n        if (arr[j] < pivot) {\n            ++i;\n            std::swap(arr[i], arr[j]);\n        }\n    }\n    std::swap(arr[i + 1], arr[high]);\n    return i + 1;\n}\n\n// Quick Sort\nvoid quickSort(std::vector<int>& arr, int low, int high) {\n    if (low < high) {\n        int pi = partition(arr, low, high);\n        quickSort(arr, low, pi - 1);\n        quickSort(arr, pi + 1, high);\n    }\n}\n\n// Function to measure the time taken by a sorting function\ntemplate <typename Func>\nvoid measureSortTime(Func sortFunction, std::vector<int> arr, const std::string& sortName) {\n    auto start = std::chrono::high_resolution_clock::now();\n    sortFunction(arr);\n    auto end = std::chrono::high_resolution_clock::now();\n    std::chrono::duration<double> elapsed = end - start;\n    std::cout << sortName << " took " << elapsed.count() << " seconds." << std::endl;\n}\n\nint main() {\n    std::string filename = INPUT_FILE_PATH_0; // Replace with your filename\n    std::vector<int> numbers = readNumbersFromFile(filename);\n    if (numbers.empty()) {\n        return 1;\n    }\n\n    std::vector<int> numbersBubble = numbers;\n    std::vector<int> numbersInsertion = numbers;\n    std::vector<int> numbersQuick = numbers;\n\n    measureSortTime(bubbleSort, numbersBubble, "Bubble Sort");\n    measureSortTime(insertionSort, numbersInsertion, "Insertion Sort");\n    measureSortTime([&](std::vector<int>& arr) { quickSort(arr, 0, arr.size() - 1); }, numbersQuick, "Quick Sort");\n\n    return 0;\n}\n	public	txt		2024-06-21 19:42:30.977933	2024-06-21 19:42:30.977933	a82ca232-27f5-4edd-a1d8-4678f55e8c8b	f
dd7734cc-3f4f-48ac-bcea-f38a122ab792	python code that transfrom sql queries to csv data and log erros in a pdf file if found \nqueries must be users inserts (name, email, password)	python	import re\nimport pandas as pd\nfrom reportlab.lib.pagesizes import letter\nfrom reportlab.pdfgen import canvas\nfrom pathlib import Path\n\ndef read_sql_queries(filename):\n    with open(filename, 'r') as file:\n        queries = file.readlines()\n    return queries\n\ndef parse_sql_query(query):\n    match = re.match(r"INSERT INTO users \\(name, email, password\\) VALUES \\('([^']+)', '([^']+)', '([^']+)'\\);", query)\n    if match:\n        return {'name': match.group(1), 'email': match.group(2), 'password': match.group(3)}\n    else:\n        return None\n\ndef write_to_csv(data, filename):\n    df = pd.DataFrame(data)\n    df.to_csv(filename, index=False)\n\ndef log_errors_to_pdf(errors, filename):\n    c = canvas.Canvas(filename, pagesize=letter)\n    width, height = letter\n    c.setFont("Helvetica", 12)\n\n    y = height - 40  # start from top of the page\n    for error in errors:\n        c.drawString(30, y, error)\n        y -= 20  # move to the next line\n        if y < 40:  # if we reach the bottom of the page\n            c.showPage()  # create a new page\n            c.setFont("Helvetica", 12)\n            y = height - 40  # reset y position\n\n    c.save()\n\ndef main():\n    input_filename = INPUT_FILE_PATH_0\n    output_csv_filename = OUTPUT_FILE_PATH_0\n    error_pdf_filename = OUTPUT_FILE_PATH_1\n\n    queries = read_sql_queries(input_filename)\n    valid_data = []\n    errors = []\n\n    for query in queries:\n        parsed_data = parse_sql_query(query.strip())\n        if parsed_data:\n            valid_data.append(parsed_data)\n        else:\n            errors.append(f"Error in query: {query.strip()}")\n\n    if valid_data:\n        write_to_csv(valid_data, output_csv_filename)\n    \n    if errors:\n        log_errors_to_pdf(errors, error_pdf_filename)\n\nif __name__ == "__main__":\n    main()\n	public	txt	csv,pdf	2024-06-21 19:52:30.65671	2024-06-21 19:52:30.65671	a82ca232-27f5-4edd-a1d8-4678f55e8c8b	f
0f81f051-ed2a-4931-87bf-544c4f6fe647	python code that takes in a png image draw an red (X) on it and returns a jpeg file from the same image 	python	from PIL import Image, ImageDraw\nimport pathlib\n\ndef draw_big_x_on_image(input_image_path, output_image_path):\n    # Open an existing image\n    with Image.open(input_image_path) as img:\n        # Create a draw object\n        draw = ImageDraw.Draw(img)\n        width, height = img.size\n\n        # Define the coordinates for the big X\n        x1, y1 = 0, 0\n        x2, y2 = width, height\n        x3, y3 = 0, height\n        x4, y4 = width, 0\n\n        # Draw two diagonal lines to form the X\n        line_width = 10  # You can adjust the width of the lines\n        draw.line((x1, y1, x2, y2), fill="red", width=line_width)\n        draw.line((x3, y3, x4, y4), fill="red", width=line_width)\n\n        # Save the image as a JPEG file\n        img = img.convert('RGB')  # Convert image to RGB mode if not already\n        img.save(output_image_path, 'JPEG')\n\ndef main():\n    input_image_path = INPUT_FILE_PATH_0 # Replace with your input PNG file path\n    output_image_path = OUTPUT_FILE_PATH_0  # Replace with your desired output JPEG file path\n    draw_big_x_on_image(input_image_path, output_image_path)\n\nif __name__ == "__main__":\n    main()\n	public	png	jpeg	2024-06-21 19:59:40.995018	2024-06-21 19:59:40.995018	645dce1e-7159-4b1b-86f0-0bc601f77b4a	f
4997a34d-85e4-4763-83e5-2dc39be7fdd9	python code that sends a get http request to (https://random-data-api.com/api/v2/users)\nand save the data in a json file	python	import requests\nimport json\nfrom pathlib import Path\n\ndef fetch_data_from_api(api_url, output_json_path):\n    response = requests.get(api_url)\n    if response.status_code == 200:\n        data = response.json()\n        with open(output_json_path, 'w') as json_file:\n            json.dump(data, json_file, indent=4)\n    else:\n        print(f"Failed to fetch data: {response.status_code}")\n\ndef main():\n    api_url = 'https://random-data-api.com/api/v2/users' # Replace with your API URL\n    output_json_path = OUTPUT_FILE_PATH_0  # Replace with your output JSON file path\n    fetch_data_from_api(api_url, output_json_path)\n\nif __name__ == "__main__":\n    main()\n	public		json	2024-06-21 20:31:17.100635	2024-06-21 20:31:17.100635	645dce1e-7159-4b1b-86f0-0bc601f77b4a	f
2556c842-c8b7-4e31-8e7b-dae4fd49b6f8	JS code to add watermark to png images 	javascript	const Jimp = require('jimp');\n\nasync function addWatermark(inputImagePath, watermarkText, outputImagePath) {\n  try {\n    const image = await Jimp.read(inputImagePath);\n    const font = await Jimp.loadFont(Jimp.FONT_SANS_32_WHITE);\n    const width = image.bitmap.width;\n    const height = image.bitmap.height;\n\n    image.print(font, width - 200, height - 50, watermarkText);\n    await image.writeAsync(outputImagePath);\n    console.log('Watermark has been added to the image.');\n  } catch (error) {\n    console.error(error);\n  }\n}\n\nconst inputImagePath = INPUT_FILE_PATH_0;\nconst watermarkText = 'Sample Watermark';\nconst outputImagePath = OUTPUT_FILE_PATH_0 ;\n\naddWatermark(inputImagePath, watermarkText, outputImagePath);\n	public	png	png	2024-06-21 21:33:14.411311	2024-06-21 21:33:14.411311	3c7ad0b2-0f68-4e9d-b2a7-1219fee50785	f
25ba8c0b-e206-475b-a899-ebf6ddb9f593	C++ sorting algorithms (buble sort / insertion sort / quick sort)	c++	#include <iostream>\n#include <vector>\n#include <algorithm>\n\n// Bubble Sort\nvoid bubbleSort(std::vector<int>& arr) {\n    int n = arr.size();\n    for (int i = 0; i < n - 1; ++i) {\n        for (int j = 0; j < n - 1 - i; ++j) {\n            if (arr[j] > arr[j + 1]) {\n                std::swap(arr[j], arr[j + 1]);\n            }\n        }\n    }\n}\n\n// Insertion Sort\nvoid insertionSort(std::vector<int>& arr) {\n    int n = arr.size();\n    for (int i = 1; i < n; ++i) {\n        int key = arr[i];\n        int j = i - 1;\n        while (j >= 0 && arr[j] > key) {\n            arr[j + 1] = arr[j];\n            --j;\n        }\n        arr[j + 1] = key;\n    }\n}\n\n// Quick Sort\nint partition(std::vector<int>& arr, int low, int high) {\n    int pivot = arr[high];\n    int i = low - 1;\n    for (int j = low; j < high; ++j) {\n        if (arr[j] < pivot) {\n            ++i;\n            std::swap(arr[i], arr[j]);\n        }\n    }\n    std::swap(arr[i + 1], arr[high]);\n    return i + 1;\n}\n\nvoid quickSort(std::vector<int>& arr, int low, int high) {\n    if (low < high) {\n        int pi = partition(arr, low, high);\n        quickSort(arr, low, pi - 1);\n        quickSort(arr, pi + 1, high);\n    }\n}\n\nint main() {\n    std::vector<int> arr1 = {34, 7, 23, 32, 5, 62};\n    std::vector<int> arr2 = arr1;\n    std::vector<int> arr3 = arr1;\n\n    bubbleSort(arr1);\n    insertionSort(arr2);\n    quickSort(arr3, 0, arr3.size() - 1);\n\n    std::cout << "Bubble Sorted: ";\n    for (int num : arr1) std::cout << num << " ";\n    std::cout << std::endl;\n\n    std::cout << "Insertion Sorted: ";\n    for (int num : arr2) std::cout << num << " ";\n    std::cout << std::endl;\n\n    std::cout << "Quick Sorted: ";\n    for (int num : arr3) std::cout << num << " ";\n    std::cout << std::endl;\n\n    return 0;\n}\n	public			2024-06-21 21:52:58.045625	2024-06-21 21:52:58.045625	6a766343-b2eb-491f-8abb-ac90dd69fa95	f
8fe11bba-6a07-4c9d-bafb-2d5682a8444e	c++ searching for elements algorithms 	c++	#include <iostream>\n#include <vector>\n#include <algorithm>\n\n// Linear Search\nint linearSearch(const std::vector<int>& arr, int target) {\n    for (int i = 0; i < arr.size(); ++i) {\n        if (arr[i] == target) {\n            return i;\n        }\n    }\n    return -1;\n}\n\n// Binary Search (Array must be sorted)\nint binarySearch(const std::vector<int>& arr, int target) {\n    int left = 0, right = arr.size() - 1;\n    while (left <= right) {\n        int mid = left + (right - left) / 2;\n        if (arr[mid] == target) {\n            return mid;\n        }\n        if (arr[mid] < target) {\n            left = mid + 1;\n        } else {\n            right = mid - 1;\n        }\n    }\n    return -1;\n}\n\nint main() {\n    std::vector<int> arr = {5, 7, 23, 32, 34, 62};\n    int target1 = 23;\n    int target2 = 62;\n\n    int index1 = linearSearch(arr, target1);\n    int index2 = binarySearch(arr, target2);\n\n    std::cout << "Linear Search: Index of " << target1 << " is " << index1 << std::endl;\n    std::cout << "Binary Search: Index of " << target2 << " is " << index2 << std::endl;\n\n    return 0;\n}\n	public			2024-06-21 21:54:19.333019	2024-06-21 21:54:19.333019	6a766343-b2eb-491f-8abb-ac90dd69fa95	f
72ac885d-73d6-4179-a7ca-71bb98cb5486	Mergin arrays in c++	c++	#include <iostream>\n#include <vector>\n#include <queue>\n\n// Merge Two Sorted Arrays\nstd::vector<int> mergeTwoSortedArrays(const std::vector<int>& arr1, const std::vector<int>& arr2) {\n    std::vector<int> result;\n    int i = 0, j = 0;\n\n    while (i < arr1.size() && j < arr2.size()) {\n        if (arr1[i] < arr2[j]) {\n            result.push_back(arr1[i++]);\n        } else {\n            result.push_back(arr2[j++]);\n        }\n    }\n\n    while (i < arr1.size()) {\n        result.push_back(arr1[i++]);\n    }\n\n    while (j < arr2.size()) {\n        result.push_back(arr2[j++]);\n    }\n\n    return result;\n}\n\n// Merge K Sorted Arrays\nstd::vector<int> mergeKSortedArrays(const std::vector<std::vector<int>>& arrays) {\n    auto compare = [](const std::pair<int, std::pair<int, int>>& a, const std::pair<int, std::pair<int, int>>& b) {\n        return a.first > b.first;\n    };\n    \n    std::priority_queue<std::pair<int, std::pair<int, int>>, std::vector<std::pair<int, std::pair<int, int>>>, decltype(compare)> minHeap(compare);\n    std::vector<int> result;\n\n    for (int i = 0; i < arrays.size(); ++i) {\n        if (!arrays[i].empty()) {\n            minHeap.push({arrays[i][0], {i, 0}});\n        }\n    }\n\n    while (!minHeap.empty()) {\n        auto [value, indices] = minHeap.top();\n        minHeap.pop();\n        result.push_back(value);\n        int arrayIndex = indices.first;\n        int elementIndex = indices.second;\n        if (elementIndex + 1 < arrays[arrayIndex].size()) {\n            minHeap.push({arrays[arrayIndex][elementIndex + 1], {arrayIndex, elementIndex + 1}});\n        }\n    }\n\n    return result;\n}\n\nint main() {\n    std::vector<int> arr1 = {1, 4, 7};\n    std::vector<int> arr2 = {2, 5, 8};\n    std::vector<int> arr3 = {3, 6, 9};\n\n    std::vector<std::vector<int>> arrays = {arr1, arr2, arr3};\n\n    std::vector<int> mergedTwo = mergeTwoSortedArrays(arr1, arr2);\n    std::vector<int> mergedK = mergeKSortedArrays(arrays);\n\n    std::cout << "Merged Two Arrays: ";\n    for (int num : mergedTwo) std::cout << num << " ";\n    std::cout << std::endl;\n\n    std::cout << "Merged K Arrays: ";\n    for (int num : mergedK) std::cout << num << " ";\n    std::cout << std::endl;\n\n    return 0;\n}\n	public			2024-06-21 21:55:13.485957	2024-06-21 21:55:13.485957	6a766343-b2eb-491f-8abb-ac90dd69fa95	f
b0d45f2b-2442-48cd-8911-591f4fcf0be7	Matrixs transformations algorithms in c++	c++	#include <iostream>\n#include <vector>\n\n// Transpose a Matrix\nstd::vector<std::vector<int>> transposeMatrix(const std::vector<std::vector<int>>& matrix) {\n    int rows = matrix.size();\n    int cols = matrix[0].size();\n    std::vector<std::vector<int>> transposed(cols, std::vector<int>(rows));\n\n    for (int i = 0; i < rows; ++i) {\n        for (int j = 0; j < cols; ++j) {\n            transposed[j][i] = matrix[i][j];\n        }\n    }\n\n    return transposed;\n}\n\n// Rotate a Matrix 90 Degrees Clockwise\nstd::vector<std::vector<int>> rotateMatrix(const std::vector<std::vector<int>>& matrix) {\n    int rows = matrix.size();\n    int cols = matrix[0].size();\n    std::vector<std::vector<int>> rotated(cols, std::vector<int>(rows));\n\n    for (int i = 0; i < rows; ++i) {\n        for (int j = 0; j < cols; ++j) {\n            rotated[j][rows - i - 1] = matrix[i][j];\n        }\n    }\n\n    return rotated;\n}\n\nint main() {\n    std::vector<std::vector<int>> matrix = {\n        {1, 2, 3},\n        {4, 5, 6},\n        {7, 8, 9}\n    };\n\n    std::vector<std::vector<int>> transposed = transposeMatrix(matrix);\n    std::vector<std::vector<int>> rotated = rotateMatrix(matrix);\n\n    std::cout << "Transposed Matrix:" << std::endl;\n    for (const auto& row : transposed) {\n        for (int num : row) std::cout << num << " ";\n        std::cout << std::endl;\n    }\n\n    std::cout << "Rotated Matrix:" << std::endl;\n    for (const auto& row : rotated) {\n        for (int num : row) std::cout << num << " ";\n        std::cout << std::endl;\n    }\n\n    return 0;\n}\n	public			2024-06-21 21:55:57.182028	2024-06-21 21:55:57.182028	6a766343-b2eb-491f-8abb-ac90dd69fa95	f
b94a2717-25d8-4468-86ef-ff848914d361	demonstration on how to use lists in c++	c++	#include <iostream>\n#include <list>\n\nint main()\n{\n    std::list<int> myList = {1, 2, 3, 4, 5};\n\n    // Adding elements\n    myList.push_back(6);\n    myList.push_front(0);\n\n    // Iterating and displaying elements\n    std::cout << "List elements: ";\n    for (const auto &element : myList)\n    {\n        std::cout << element << " ";\n    }\n    std::cout << std::endl;\n\n    // Accessing elements\n    std::cout << "First element: " << myList.front() << std::endl;\n    std::cout << "Last element: " << myList.back() << std::endl;\n\n    // Removing elements\n    myList.pop_back();\n    myList.pop_front();\n\n    // Displaying elements after removal\n    std::cout << "List elements after pop operations: ";\n    for (const auto &element : myList)\n    {\n        std::cout << element << " ";\n    }\n    std::cout << std::endl;\n\n    return 0;\n}\n	private			2024-06-22 18:46:50.437755	2024-06-22 18:46:50.437755	f927fc08-8f8a-4a0b-adec-d924091dcad1	t
f78c6ff8-c684-42cf-96e5-729f6eea2c2a	c++ lists demonstration	c++	#include <iostream>\n#include <list>\n\nint main()\n{\n    std::list<int> myList = {1, 2, 3, 4, 5};\n\n    // Adding elements\n    myList.push_back(6);\n    myList.push_front(0);\n\n    // Iterating and displaying elements\n    std::cout << "List elements: ";\n    for (const auto &element : myList)\n    {\n        std::cout << element << " ";\n    }\n    std::cout << std::endl;\n\n    // Accessing elements\n    std::cout << "First element: " << myList.front() << std::endl;\n    std::cout << "Last element: " << myList.back() << std::endl;\n\n    // Removing elements\n    myList.pop_back();\n    myList.pop_front();\n\n    // Displaying elements after removal\n    std::cout << "List elements after pop operations: ";\n    for (const auto &element : myList)\n    {\n        std::cout << element << " ";\n    }\n    std::cout << std::endl;\n\n    return 0;\n}\n	private			2024-06-22 18:47:31.300957	2024-06-22 18:47:31.300957	f927fc08-8f8a-4a0b-adec-d924091dcad1	t
\.


--
-- Data for Name: program-version; Type: TABLE DATA; Schema: public; Owner: psql
--

COPY public."program-version" ("programVersionId", version, "programmingLanguage", "sourceCode", "createdAt", "programProgramId") FROM stdin;
\.


--
-- Data for Name: program-versions; Type: TABLE DATA; Schema: public; Owner: psql
--

COPY public."program-versions" ("programVersionId", version, "programmingLanguage", "sourceCode", "createdAt", "programProgramId") FROM stdin;
\.


--
-- Data for Name: program_version_entity; Type: TABLE DATA; Schema: public; Owner: psql
--

COPY public.program_version_entity ("programVersionId", version, "programmingLanguage", "sourceCode", "createdAt", "programProgramId") FROM stdin;
\.


--
-- Data for Name: reaction_entity; Type: TABLE DATA; Schema: public; Owner: psql
--

COPY public.reaction_entity ("reactionId", type, "createdAt", "userId", "programId") FROM stdin;
64e2e176-1d43-4e43-863d-203316c55e2a	dislike	2024-06-22 10:01:00	d1dbec9d-ce36-42b3-a467-0b1512f41545	bb155671-05c6-46cd-a043-72547a413430
8545a1ac-1e54-43c6-a4ac-b17d2fb8df32	like	2024-06-22 10:02:00	f3c04916-f30d-4360-b465-c5eb262dce94	4997a34d-85e4-4763-83e5-2dc39be7fdd9
17c98c0c-57a2-4705-9e5f-7beb87eb4c43	dislike	2024-06-22 10:03:00	76da11f5-10d2-4e79-af6d-1b92c4f2a0c0	0f81f051-ed2a-4931-87bf-544c4f6fe647
1420ea9a-3af1-4106-a876-767dfec2d1ce	like	2024-06-22 10:04:00	960823cf-d908-4246-8fa0-0ac6118797ca	dd7734cc-3f4f-48ac-bcea-f38a122ab792
b50e2e3d-2e7b-4f86-b0a0-60cd5e68faab	dislike	2024-06-22 10:05:00	cd3675d5-61d6-4adf-96d8-bb5867342208	b85d1b4b-f01d-41f8-b273-ac2816c566b5
68309e0e-daad-4a85-9c93-c7fe65c02a4a	like	2024-06-22 10:06:00	a9b20768-6469-4d39-b0aa-c4ed19ae9897	b0d45f2b-2442-48cd-8911-591f4fcf0be7
ea0c5151-1f9f-46eb-955c-1aaaf1378353	dislike	2024-06-22 10:07:00	3c7ad0b2-0f68-4e9d-b2a7-1219fee50785	72ac885d-73d6-4179-a7ca-71bb98cb5486
f2332b28-65e1-41ef-8e98-29cba0743836	like	2024-06-22 10:08:00	7575e78a-a78b-4900-9fb3-b30c925e5f89	8fe11bba-6a07-4c9d-bafb-2d5682a8444e
2ee461cd-20ef-4463-8c45-5e72c1116d39	dislike	2024-06-22 10:09:00	f927fc08-8f8a-4a0b-adec-d924091dcad1	25ba8c0b-e206-475b-a899-ebf6ddb9f593
63f3a864-d3c6-482b-90b7-6bf69c8fa6d4	like	2024-06-22 10:10:00	2bebe474-6406-409e-904c-ff7865ac755e	327c8fef-d34c-45e8-aec2-0d226e8347ad
96a8247e-7bbe-46e4-8d64-722f3d28aa72	dislike	2024-06-22 10:11:00	7472ab8a-901e-4dac-a330-9bbe4eda5a5a	e0ecda2a-7159-4e41-bff6-53a6e34060a8
3080ee02-8d84-46c1-b870-99fda09087f3	like	2024-06-22 10:12:00	c0cc7f72-bfb8-497c-8f42-3954aeb91b1c	2556c842-c8b7-4e31-8e7b-dae4fd49b6f8
bac7ac1d-bb77-43e3-9837-3bf7fa75df78	dislike	2024-06-22 10:13:00	f8c6500d-bbf6-4c88-959c-c67c7e572fc0	bb155671-05c6-46cd-a043-72547a413430
2ed33098-42a0-4b68-9f65-aade12d5ab64	like	2024-06-22 10:14:00	745820cf-14e3-4837-be8a-2f7151ec9131	4997a34d-85e4-4763-83e5-2dc39be7fdd9
65e4aceb-8785-475c-9df6-22aa534bd651	dislike	2024-06-22 10:15:00	57d296e1-7af7-4cfc-afd2-7bc6352a65e6	0f81f051-ed2a-4931-87bf-544c4f6fe647
6e1198ad-7227-47f1-9d54-b247b5e96431	like	2024-06-22 10:16:00	a96df0df-f4a1-4d82-a655-2f7f94ace896	dd7734cc-3f4f-48ac-bcea-f38a122ab792
5b1b146d-7d9c-40e5-adf0-1502ba9ca4ca	dislike	2024-06-22 10:17:00	d1dbec9d-ce36-42b3-a467-0b1512f41545	b85d1b4b-f01d-41f8-b273-ac2816c566b5
2b16b39d-d6b0-47f9-b74e-361f03c4c7a7	like	2024-06-22 10:18:00	f3c04916-f30d-4360-b465-c5eb262dce94	b0d45f2b-2442-48cd-8911-591f4fcf0be7
4a8140b2-915f-4429-8b81-0ba27ceb9809	dislike	2024-06-22 10:19:00	76da11f5-10d2-4e79-af6d-1b92c4f2a0c0	72ac885d-73d6-4179-a7ca-71bb98cb5486
225f9c7e-1680-4830-b0fa-ba534ef3c0da	like	2024-06-22 10:20:00	960823cf-d908-4246-8fa0-0ac6118797ca	8fe11bba-6a07-4c9d-bafb-2d5682a8444e
6b7b98d5-4b53-4c56-aa35-6ad337c472a9	dislike	2024-06-22 10:21:00	cd3675d5-61d6-4adf-96d8-bb5867342208	25ba8c0b-e206-475b-a899-ebf6ddb9f593
e475b8ff-6ada-4121-9def-69413a540542	like	2024-06-22 10:22:00	a9b20768-6469-4d39-b0aa-c4ed19ae9897	327c8fef-d34c-45e8-aec2-0d226e8347ad
189f73d6-55fa-41a5-bdad-0b36d1417766	dislike	2024-06-22 10:23:00	3c7ad0b2-0f68-4e9d-b2a7-1219fee50785	e0ecda2a-7159-4e41-bff6-53a6e34060a8
4c775339-886d-473f-9a31-fa80a035afb7	like	2024-06-22 10:24:00	7575e78a-a78b-4900-9fb3-b30c925e5f89	2556c842-c8b7-4e31-8e7b-dae4fd49b6f8
8d0f1e91-bbf1-4cf7-a17e-00a06521c550	dislike	2024-06-22 10:25:00	f927fc08-8f8a-4a0b-adec-d924091dcad1	bb155671-05c6-46cd-a043-72547a413430
11dda0c1-bcb6-46d8-8b43-83c12b613ee9	like	2024-06-22 10:26:00	2bebe474-6406-409e-904c-ff7865ac755e	4997a34d-85e4-4763-83e5-2dc39be7fdd9
efe1085d-4872-4797-846e-00c55e9505ed	dislike	2024-06-22 10:27:00	7472ab8a-901e-4dac-a330-9bbe4eda5a5a	0f81f051-ed2a-4931-87bf-544c4f6fe647
60cfdd79-1f57-4c0e-9093-6d9002382d40	like	2024-06-22 10:28:00	c0cc7f72-bfb8-497c-8f42-3954aeb91b1c	dd7734cc-3f4f-48ac-bcea-f38a122ab792
f2c462a4-679c-470b-b9a3-f7664e16a95c	dislike	2024-06-22 10:29:00	f8c6500d-bbf6-4c88-959c-c67c7e572fc0	b85d1b4b-f01d-41f8-b273-ac2816c566b5
8aea7e76-d808-42f4-a8d3-a574accec1ba	like	2024-06-22 10:30:00	745820cf-14e3-4837-be8a-2f7151ec9131	b0d45f2b-2442-48cd-8911-591f4fcf0be7
6ca4c43c-ca77-4f41-8da4-0b995fe4fe31	dislike	2024-06-22 10:31:00	57d296e1-7af7-4cfc-afd2-7bc6352a65e6	72ac885d-73d6-4179-a7ca-71bb98cb5486
2c9de7b9-1cee-4827-a164-9d2ef65f1dca	like	2024-06-22 10:32:00	a96df0df-f4a1-4d82-a655-2f7f94ace896	8fe11bba-6a07-4c9d-bafb-2d5682a8444e
25fb336f-d82f-45c2-abf9-eef7c8b06c26	dislike	2024-06-22 10:33:00	d1dbec9d-ce36-42b3-a467-0b1512f41545	25ba8c0b-e206-475b-a899-ebf6ddb9f593
3cffc5e2-09b6-4ac3-a3f4-578c3f9e2cab	like	2024-06-22 10:34:00	f3c04916-f30d-4360-b465-c5eb262dce94	327c8fef-d34c-45e8-aec2-0d226e8347ad
d1568bdb-9c11-488d-9c41-0f413a6d5826	dislike	2024-06-22 10:35:00	76da11f5-10d2-4e79-af6d-1b92c4f2a0c0	e0ecda2a-7159-4e41-bff6-53a6e34060a8
05cc3b5e-6fe9-4289-89dc-681c40d3e917	like	2024-06-22 10:36:00	960823cf-d908-4246-8fa0-0ac6118797ca	2556c842-c8b7-4e31-8e7b-dae4fd49b6f8
5b616685-1024-4237-b30c-55a3352fd618	like	2024-06-22 12:13:00	d1dbec9d-ce36-42b3-a467-0b1512f41545	4997a34d-85e4-4763-83e5-2dc39be7fdd9
12d53169-4331-4d31-8881-f3617622d5f3	dislike	2024-06-22 12:14:00	f3c04916-f30d-4360-b465-c5eb262dce94	0f81f051-ed2a-4931-87bf-544c4f6fe647
5ecd83f4-c9c8-4099-a24c-8535e4ab0b74	like	2024-06-22 12:15:00	76da11f5-10d2-4e79-af6d-1b92c4f2a0c0	dd7734cc-3f4f-48ac-bcea-f38a122ab792
8a2293a4-5394-4ed9-bc1c-d6cc7b604b25	dislike	2024-06-22 12:16:00	960823cf-d908-4246-8fa0-0ac6118797ca	b85d1b4b-f01d-41f8-b273-ac2816c566b5
e99ab931-af88-4e87-8b09-08eaea3bbf37	like	2024-06-22 12:17:00	cd3675d5-61d6-4adf-96d8-bb5867342208	b0d45f2b-2442-48cd-8911-591f4fcf0be7
5452902d-d7a2-41d3-85ee-953e680419e8	dislike	2024-06-22 12:18:00	a9b20768-6469-4d39-b0aa-c4ed19ae9897	72ac885d-73d6-4179-a7ca-71bb98cb5486
4c9d2cad-5420-4bec-9dcc-0ed0051f2eae	like	2024-06-22 12:19:00	3c7ad0b2-0f68-4e9d-b2a7-1219fee50785	8fe11bba-6a07-4c9d-bafb-2d5682a8444e
e78e8c0c-e2eb-470b-a66a-af5c52005184	dislike	2024-06-22 12:20:00	7575e78a-a78b-4900-9fb3-b30c925e5f89	25ba8c0b-e206-475b-a899-ebf6ddb9f593
6a2f2e7a-b29d-4f95-8fe6-33c2935de4e5	like	2024-06-22 12:21:00	f927fc08-8f8a-4a0b-adec-d924091dcad1	327c8fef-d34c-45e8-aec2-0d226e8347ad
2b965f0e-3f0f-47bd-9bcd-eb230e94322f	dislike	2024-06-22 12:22:00	2bebe474-6406-409e-904c-ff7865ac755e	e0ecda2a-7159-4e41-bff6-53a6e34060a8
cde73375-2d16-4306-9a10-d817519129af	like	2024-06-22 12:23:00	7472ab8a-901e-4dac-a330-9bbe4eda5a5a	2556c842-c8b7-4e31-8e7b-dae4fd49b6f8
bec538a9-fbc5-49f7-b7b3-ea2e4197684b	dislike	2024-06-22 12:24:00	c0cc7f72-bfb8-497c-8f42-3954aeb91b1c	bb155671-05c6-46cd-a043-72547a413430
0bac8cf1-6c99-447a-8d5d-7c0300dbcf55	like	2024-06-22 12:25:00	f8c6500d-bbf6-4c88-959c-c67c7e572fc0	4997a34d-85e4-4763-83e5-2dc39be7fdd9
c10beee0-f930-4f1e-be4e-647d721bd989	dislike	2024-06-22 12:26:00	745820cf-14e3-4837-be8a-2f7151ec9131	0f81f051-ed2a-4931-87bf-544c4f6fe647
af5199ba-e457-42b5-8170-6210364265dd	like	2024-06-22 12:27:00	57d296e1-7af7-4cfc-afd2-7bc6352a65e6	dd7734cc-3f4f-48ac-bcea-f38a122ab792
6a63f16b-609e-4628-8413-41a8528f6b7a	dislike	2024-06-22 12:28:00	a96df0df-f4a1-4d82-a655-2f7f94ace896	b85d1b4b-f01d-41f8-b273-ac2816c566b5
8af950e5-943d-4407-b42c-4a56d9444d19	like	2024-06-22 12:29:00	d1dbec9d-ce36-42b3-a467-0b1512f41545	b0d45f2b-2442-48cd-8911-591f4fcf0be7
3f5b96fa-bbd7-4c1b-97b3-d4cc8c87dd07	dislike	2024-06-22 12:30:00	f3c04916-f30d-4360-b465-c5eb262dce94	72ac885d-73d6-4179-a7ca-71bb98cb5486
3ccb2cf0-95db-422a-9ec6-2f87d449da7f	like	2024-06-22 12:31:00	76da11f5-10d2-4e79-af6d-1b92c4f2a0c0	8fe11bba-6a07-4c9d-bafb-2d5682a8444e
8289057a-ff2b-4972-8323-24fd7dff16f6	dislike	2024-06-22 12:32:00	960823cf-d908-4246-8fa0-0ac6118797ca	25ba8c0b-e206-475b-a899-ebf6ddb9f593
dc8c3191-d2b3-4444-835d-6ed93b6efd56	dislike	2024-06-22 12:33:00	cd3675d5-61d6-4adf-96d8-bb5867342208	327c8fef-d34c-45e8-aec2-0d226e8347ad
64c7f177-3a5a-4c1f-8160-7cf3e5febc5d	like	2024-06-22 12:34:00	a9b20768-6469-4d39-b0aa-c4ed19ae9897	e0ecda2a-7159-4e41-bff6-53a6e34060a8
2102ef94-8bd9-4360-9640-e2c1ba9f9464	dislike	2024-06-22 12:35:00	3c7ad0b2-0f68-4e9d-b2a7-1219fee50785	2556c842-c8b7-4e31-8e7b-dae4fd49b6f8
2fee7aad-fcbe-407b-a813-3abf8a671bb5	like	2024-06-22 12:36:00	7575e78a-a78b-4900-9fb3-b30c925e5f89	bb155671-05c6-46cd-a043-72547a413430
0b4a5076-e67a-4d39-a8ac-2f85744b8604	dislike	2024-06-22 12:37:00	f927fc08-8f8a-4a0b-adec-d924091dcad1	4997a34d-85e4-4763-83e5-2dc39be7fdd9
33fb56be-6413-4852-956f-e3fabf751974	like	2024-06-22 12:38:00	2bebe474-6406-409e-904c-ff7865ac755e	0f81f051-ed2a-4931-87bf-544c4f6fe647
5d0a17e0-409c-4ed7-8a26-5e199c0b12fd	dislike	2024-06-22 12:39:00	7472ab8a-901e-4dac-a330-9bbe4eda5a5a	dd7734cc-3f4f-48ac-bcea-f38a122ab792
33d26c48-9552-45fa-a646-704d42782016	like	2024-06-22 12:40:00	c0cc7f72-bfb8-497c-8f42-3954aeb91b1c	b85d1b4b-f01d-41f8-b273-ac2816c566b5
636f7fdf-09d0-4f21-a2fa-cb03ed63ac7a	dislike	2024-06-22 12:41:00	f8c6500d-bbf6-4c88-959c-c67c7e572fc0	b0d45f2b-2442-48cd-8911-591f4fcf0be7
2f664628-a3fa-4380-a9e9-bffc76f38d18	like	2024-06-22 12:42:00	745820cf-14e3-4837-be8a-2f7151ec9131	72ac885d-73d6-4179-a7ca-71bb98cb5486
ff774150-f2af-4c52-99c3-c724988cc6cd	dislike	2024-06-22 12:43:00	57d296e1-7af7-4cfc-afd2-7bc6352a65e6	8fe11bba-6a07-4c9d-bafb-2d5682a8444e
990635e8-e41a-491b-a8cb-ce36145f2c36	like	2024-06-22 12:44:00	a96df0df-f4a1-4d82-a655-2f7f94ace896	25ba8c0b-e206-475b-a899-ebf6ddb9f593
e410a815-0277-42c8-a829-8c9a1443eea1	dislike	2024-06-22 12:45:00	d1dbec9d-ce36-42b3-a467-0b1512f41545	327c8fef-d34c-45e8-aec2-0d226e8347ad
572b85bd-11d3-4392-9947-fac7d5c3e341	like	2024-06-22 12:46:00	f3c04916-f30d-4360-b465-c5eb262dce94	e0ecda2a-7159-4e41-bff6-53a6e34060a8
4deb63c4-e4eb-45fb-9b6f-66b0bc47cb2b	dislike	2024-06-22 12:47:00	76da11f5-10d2-4e79-af6d-1b92c4f2a0c0	2556c842-c8b7-4e31-8e7b-dae4fd49b6f8
ebf50858-2a65-4abc-802c-38706c16ca87	like	2024-06-22 12:48:00	960823cf-d908-4246-8fa0-0ac6118797ca	bb155671-05c6-46cd-a043-72547a413430
ef97b54b-f734-4830-98fb-582a8feaa54c	dislike	2024-06-22 12:49:00	cd3675d5-61d6-4adf-96d8-bb5867342208	4997a34d-85e4-4763-83e5-2dc39be7fdd9
28c3e551-1545-452b-8b7d-fd6b6385ac82	like	2024-06-22 12:50:00	a9b20768-6469-4d39-b0aa-c4ed19ae9897	0f81f051-ed2a-4931-87bf-544c4f6fe647
2bb31615-67f4-47de-8f6b-0f3b7fad5562	dislike	2024-06-22 12:51:00	3c7ad0b2-0f68-4e9d-b2a7-1219fee50785	dd7734cc-3f4f-48ac-bcea-f38a122ab792
0c7d72fe-a943-492f-a331-a6e0259ff932	like	2024-06-22 12:52:00	7575e78a-a78b-4900-9fb3-b30c925e5f89	b85d1b4b-f01d-41f8-b273-ac2816c566b5
5d2c202a-86ca-4da1-8337-648503038d75	like	2024-06-22 16:07:13.645145	6a766343-b2eb-491f-8abb-ac90dd69fa95	88e39a98-56a3-4d25-936a-21dae870d0b3
421f6103-40da-48e4-82ea-6bcd9d367f95	like	2024-06-22 16:07:15.85617	6a766343-b2eb-491f-8abb-ac90dd69fa95	2556c842-c8b7-4e31-8e7b-dae4fd49b6f8
5f61db90-2bc4-4575-94bb-ab9b0625eb5b	dislike	2024-06-22 16:07:17.898116	6a766343-b2eb-491f-8abb-ac90dd69fa95	327c8fef-d34c-45e8-aec2-0d226e8347ad
703ade4a-4e1e-4bbe-8057-f76d27671a1b	dislike	2024-06-22 16:07:20.08813	6a766343-b2eb-491f-8abb-ac90dd69fa95	72ac885d-73d6-4179-a7ca-71bb98cb5486
103ec02e-4b4e-4a29-930a-0f06f97f828b	like	2024-06-22 16:07:22.39986	6a766343-b2eb-491f-8abb-ac90dd69fa95	b0d45f2b-2442-48cd-8911-591f4fcf0be7
0b52e003-dd1f-4636-9c88-bde3a66d2c7a	like	2024-06-22 16:07:23.708881	6a766343-b2eb-491f-8abb-ac90dd69fa95	b85d1b4b-f01d-41f8-b273-ac2816c566b5
96df8001-467a-4f29-b61e-2edbb50f9670	dislike	2024-06-22 16:07:25.842857	6a766343-b2eb-491f-8abb-ac90dd69fa95	8fe11bba-6a07-4c9d-bafb-2d5682a8444e
b278287c-a89b-4e3c-9e5c-8d8f5df41c2c	like	2024-06-22 16:07:30.745508	6a766343-b2eb-491f-8abb-ac90dd69fa95	e0ecda2a-7159-4e41-bff6-53a6e34060a8
51e9c52a-7e91-4a7c-9409-220f0b27555e	dislike	2024-06-22 16:07:37.779101	6a766343-b2eb-491f-8abb-ac90dd69fa95	4997a34d-85e4-4763-83e5-2dc39be7fdd9
ef6283ac-0925-4488-9a32-4ba6218a9e37	dislike	2024-06-22 16:07:40.009715	6a766343-b2eb-491f-8abb-ac90dd69fa95	bb155671-05c6-46cd-a043-72547a413430
3c5a47a1-e78a-43d5-8308-aabefdb0c563	dislike	2024-06-22 16:38:08.963322	9623ff85-67b1-4f4d-8b48-1544c3cb38ab	4997a34d-85e4-4763-83e5-2dc39be7fdd9
ca7e2646-daba-4fce-880c-138bcc436c1b	like	2024-06-22 16:38:10.848828	9623ff85-67b1-4f4d-8b48-1544c3cb38ab	0f81f051-ed2a-4931-87bf-544c4f6fe647
b3f796ef-93a6-4e2c-a4b7-0704cbf7d755	dislike	2024-06-22 16:38:12.116711	9623ff85-67b1-4f4d-8b48-1544c3cb38ab	b85d1b4b-f01d-41f8-b273-ac2816c566b5
cdde4ed1-d4bc-4b16-9e72-728521790382	like	2024-06-22 16:38:17.830213	9623ff85-67b1-4f4d-8b48-1544c3cb38ab	b0d45f2b-2442-48cd-8911-591f4fcf0be7
ba09eee2-e526-4865-94c5-ff4730b10e00	like	2024-06-22 16:38:21.658043	9623ff85-67b1-4f4d-8b48-1544c3cb38ab	327c8fef-d34c-45e8-aec2-0d226e8347ad
0f860612-0a39-494e-a809-0f1bb6452871	like	2024-06-22 16:38:23.72741	9623ff85-67b1-4f4d-8b48-1544c3cb38ab	25ba8c0b-e206-475b-a899-ebf6ddb9f593
70eaaa1f-54b8-468f-8318-12a8bddaca02	like	2024-06-22 16:38:27.854762	9623ff85-67b1-4f4d-8b48-1544c3cb38ab	88e39a98-56a3-4d25-936a-21dae870d0b3
578dc490-7ca1-4b32-ba47-369069c50826	dislike	2024-06-22 16:38:31.637446	9623ff85-67b1-4f4d-8b48-1544c3cb38ab	bb155671-05c6-46cd-a043-72547a413430
dde4b37a-7353-4b77-9b1a-c36dd00972a1	like	2024-06-22 16:38:39.455798	9623ff85-67b1-4f4d-8b48-1544c3cb38ab	dd7734cc-3f4f-48ac-bcea-f38a122ab792
a0135247-027a-4f53-8578-b4437bbff6c8	like	2024-06-22 16:38:25.66358	9623ff85-67b1-4f4d-8b48-1544c3cb38ab	e0ecda2a-7159-4e41-bff6-53a6e34060a8
ea9b9cb6-192f-4389-a73a-53ee6dad2e2b	like	2024-06-22 21:33:55.207523	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	b94a2717-25d8-4468-86ef-ff848914d361
b3da75cc-9795-46fb-825d-8a6084ea9fcd	like	2024-06-22 21:56:25.523884	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	bb155671-05c6-46cd-a043-72547a413430
8917a5fc-e3e2-49f3-b2cf-768975a95dd8	like	2024-06-22 21:56:31.360474	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	dd7734cc-3f4f-48ac-bcea-f38a122ab792
40cc0fbe-0b00-44e4-b253-900a2ccaf960	dislike	2024-06-22 21:56:34.57689	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	b85d1b4b-f01d-41f8-b273-ac2816c566b5
ee7a2e21-6091-4446-b613-16883ca03a0d	like	2024-06-22 21:56:37.223913	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	b0d45f2b-2442-48cd-8911-591f4fcf0be7
e20b00ba-feaf-4986-8d3c-24df19b05fae	like	2024-06-22 21:56:41.445215	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	8fe11bba-6a07-4c9d-bafb-2d5682a8444e
16190250-8847-4b5f-84f8-c791f80b2639	like	2024-06-22 21:56:46.490668	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	e0ecda2a-7159-4e41-bff6-53a6e34060a8
3776f71b-3a67-43fb-b952-0cda58da1d61	dislike	2024-06-22 21:56:52.99965	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	88e39a98-56a3-4d25-936a-21dae870d0b3
1718fd72-730f-4512-8f39-96b27b6ad995	like	2024-06-22 21:28:56.053781	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	f78c6ff8-c684-42cf-96e5-729f6eea2c2a
2a221149-1242-405b-8b1a-32a4722ec6a9	like	2024-06-22 20:10:13.375955	fcbe60a2-78a6-4f4c-951f-da6422cb80c3	20ff146f-bd26-4272-8dce-016480cf0455
f316b06e-5ab2-4b6d-bc8e-61b244b1137e	like	2024-06-22 23:58:49.298945	f927fc08-8f8a-4a0b-adec-d924091dcad1	f78c6ff8-c684-42cf-96e5-729f6eea2c2a
ae0ad465-b334-48f4-9894-f6af25beb2a5	dislike	2024-06-22 23:52:06.275632	f927fc08-8f8a-4a0b-adec-d924091dcad1	20ff146f-bd26-4272-8dce-016480cf0455
e3c6148b-7772-47cf-9773-7f8c748bdd32	like	2024-06-23 13:02:34.336316	f8c6500d-bbf6-4c88-959c-c67c7e572fc0	dd7734cc-3f4f-48ac-bcea-f38a122ab792
a62f6e82-0f71-4e2a-8901-076df93862ff	like	2024-06-23 13:02:43.942379	f8c6500d-bbf6-4c88-959c-c67c7e572fc0	72ac885d-73d6-4179-a7ca-71bb98cb5486
f08f7237-afb4-4f70-81fc-52c08e4e55d2	like	2024-06-23 13:09:47.220532	f8c6500d-bbf6-4c88-959c-c67c7e572fc0	20ff146f-bd26-4272-8dce-016480cf0455
c40f01c1-1113-4994-b279-fd1cc6807fb7	dislike	2024-06-23 13:04:19.150921	f8c6500d-bbf6-4c88-959c-c67c7e572fc0	f78c6ff8-c684-42cf-96e5-729f6eea2c2a
894005af-782f-4e0a-a55b-f4543a0919b1	like	2024-06-23 00:05:03.041437	b0ed894a-610d-498c-b11f-ed47d2a87b29	f78c6ff8-c684-42cf-96e5-729f6eea2c2a
8db9585f-72e0-4da8-80fb-9c3040c1625b	dislike	2024-06-23 00:03:48.682112	b0ed894a-610d-498c-b11f-ed47d2a87b29	b94a2717-25d8-4468-86ef-ff848914d361
710ecbdf-4c8b-45eb-afa0-2ed1055e6dc3	dislike	2024-06-23 20:04:22.21698	b0ed894a-610d-498c-b11f-ed47d2a87b29	20ff146f-bd26-4272-8dce-016480cf0455
54aa4bc0-3a4c-49b2-83c9-237be0efae6a	like	2024-06-23 20:04:37.767928	b0ed894a-610d-498c-b11f-ed47d2a87b29	bb155671-05c6-46cd-a043-72547a413430
114d53fc-8f6c-41b2-97ee-6a99b49fbe25	dislike	2024-06-23 20:04:39.690901	b0ed894a-610d-498c-b11f-ed47d2a87b29	4997a34d-85e4-4763-83e5-2dc39be7fdd9
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: psql
--

COPY public."user" ("userId", "userName", "firstName", "lastName", email, password, "avatarUrl", bio, "isVerified", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: user_groups; Type: TABLE DATA; Schema: public; Owner: psql
--

COPY public.user_groups ("userId", "groupId") FROM stdin;
d1ec15b3-32ad-42af-b82b-32e4ccccca84	b239d202-2b9d-44b5-9f94-a596fbcdf608
d1ec15b3-32ad-42af-b82b-32e4ccccca84	76de736c-3969-4979-8f1a-6a4afe6d8d7e
f8c6500d-bbf6-4c88-959c-c67c7e572fc0	b239d202-2b9d-44b5-9f94-a596fbcdf608
a96df0df-f4a1-4d82-a655-2f7f94ace896	76de736c-3969-4979-8f1a-6a4afe6d8d7e
d1dbec9d-ce36-42b3-a467-0b1512f41545	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
f3c04916-f30d-4360-b465-c5eb262dce94	b239d202-2b9d-44b5-9f94-a596fbcdf608
76da11f5-10d2-4e79-af6d-1b92c4f2a0c0	9704c250-2c29-4f49-a5dc-c3fface6a852
960823cf-d908-4246-8fa0-0ac6118797ca	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
3c7ad0b2-0f68-4e9d-b2a7-1219fee50785	21de695d-1881-42e4-a55a-488e7b9803cb
cd3675d5-61d6-4adf-96d8-bb5867342208	3d534968-0a02-4591-a212-9bcea2647345
b0afe2ef-0b3d-481d-9654-f9e67207757d	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
a9b20768-6469-4d39-b0aa-c4ed19ae9897	76de736c-3969-4979-8f1a-6a4afe6d8d7e
04b123c0-c2ed-464f-b848-5637bbd7d89d	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
2bdf8bc5-7def-47aa-94ca-7f298307ab35	b239d202-2b9d-44b5-9f94-a596fbcdf608
fcbe60a2-78a6-4f4c-951f-da6422cb80c3	9704c250-2c29-4f49-a5dc-c3fface6a852
6f67e1b3-4b5b-4359-b7ea-583eebbfde21	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
693dab47-5108-490b-9a10-97ff75796112	21de695d-1881-42e4-a55a-488e7b9803cb
31c3d5b3-8c7c-4cef-a037-2eccb1839791	3d534968-0a02-4591-a212-9bcea2647345
645dce1e-7159-4b1b-86f0-0bc601f77b4a	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
6a432d6d-6f5f-4d42-a364-efa8a1a9d1e1	76de736c-3969-4979-8f1a-6a4afe6d8d7e
16eca672-7fea-4e30-a715-4aaac96518ce	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
0f6a77b3-b0c1-420a-943d-2ca4b161991d	9704c250-2c29-4f49-a5dc-c3fface6a852
a82ca232-27f5-4edd-a1d8-4678f55e8c8b	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
64d12d2a-f5a9-4109-b79f-561e15f878b6	21de695d-1881-42e4-a55a-488e7b9803cb
c6ef708c-22a7-4dea-85a9-bfc2f5e63608	3d534968-0a02-4591-a212-9bcea2647345
f2d14b9e-18a1-4479-a5da-835c7443586f	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
6a766343-b2eb-491f-8abb-ac90dd69fa95	76de736c-3969-4979-8f1a-6a4afe6d8d7e
d9500d74-9405-4bb6-89b9-6b19147f2cc8	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
220672be-7563-4b84-83f0-cbd497765462	b239d202-2b9d-44b5-9f94-a596fbcdf608
9623ff85-67b1-4f4d-8b48-1544c3cb38ab	9704c250-2c29-4f49-a5dc-c3fface6a852
7575e78a-a78b-4900-9fb3-b30c925e5f89	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
c02fcc25-b9f3-4473-bf1a-80abbdc73474	21de695d-1881-42e4-a55a-488e7b9803cb
2bdba617-734f-48a5-844c-c7ca5a68781b	3d534968-0a02-4591-a212-9bcea2647345
2bebe474-6406-409e-904c-ff7865ac755e	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
b0ed894a-610d-498c-b11f-ed47d2a87b29	76de736c-3969-4979-8f1a-6a4afe6d8d7e
f927fc08-8f8a-4a0b-adec-d924091dcad1	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
4ac4c910-d783-48d5-ae41-b542e8cb666f	b239d202-2b9d-44b5-9f94-a596fbcdf608
7472ab8a-901e-4dac-a330-9bbe4eda5a5a	9704c250-2c29-4f49-a5dc-c3fface6a852
7d2d10ef-c751-4b4c-aff4-8f47c9952491	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
c0cc7f72-bfb8-497c-8f42-3954aeb91b1c	21de695d-1881-42e4-a55a-488e7b9803cb
f8c6500d-bbf6-4c88-959c-c67c7e572fc0	3d534968-0a02-4591-a212-9bcea2647345
5d1b295d-a018-49a2-9c53-a639a3bf51ef	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
745820cf-14e3-4837-be8a-2f7151ec9131	76de736c-3969-4979-8f1a-6a4afe6d8d7e
9e00a085-1e03-4bb5-b18d-65d93f16f743	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
57d296e1-7af7-4cfc-afd2-7bc6352a65e6	b239d202-2b9d-44b5-9f94-a596fbcdf608
d1dbec9d-ce36-42b3-a467-0b1512f41545	9704c250-2c29-4f49-a5dc-c3fface6a852
f3c04916-f30d-4360-b465-c5eb262dce94	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
76da11f5-10d2-4e79-af6d-1b92c4f2a0c0	21de695d-1881-42e4-a55a-488e7b9803cb
960823cf-d908-4246-8fa0-0ac6118797ca	3d534968-0a02-4591-a212-9bcea2647345
3c7ad0b2-0f68-4e9d-b2a7-1219fee50785	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
cd3675d5-61d6-4adf-96d8-bb5867342208	76de736c-3969-4979-8f1a-6a4afe6d8d7e
b0afe2ef-0b3d-481d-9654-f9e67207757d	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
a9b20768-6469-4d39-b0aa-c4ed19ae9897	b239d202-2b9d-44b5-9f94-a596fbcdf608
04b123c0-c2ed-464f-b848-5637bbd7d89d	9704c250-2c29-4f49-a5dc-c3fface6a852
2bdf8bc5-7def-47aa-94ca-7f298307ab35	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
fcbe60a2-78a6-4f4c-951f-da6422cb80c3	21de695d-1881-42e4-a55a-488e7b9803cb
6f67e1b3-4b5b-4359-b7ea-583eebbfde21	3d534968-0a02-4591-a212-9bcea2647345
693dab47-5108-490b-9a10-97ff75796112	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
31c3d5b3-8c7c-4cef-a037-2eccb1839791	76de736c-3969-4979-8f1a-6a4afe6d8d7e
645dce1e-7159-4b1b-86f0-0bc601f77b4a	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
6a432d6d-6f5f-4d42-a364-efa8a1a9d1e1	b239d202-2b9d-44b5-9f94-a596fbcdf608
16eca672-7fea-4e30-a715-4aaac96518ce	9704c250-2c29-4f49-a5dc-c3fface6a852
d1ec15b3-32ad-42af-b82b-32e4ccccca84	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
0f6a77b3-b0c1-420a-943d-2ca4b161991d	21de695d-1881-42e4-a55a-488e7b9803cb
a82ca232-27f5-4edd-a1d8-4678f55e8c8b	3d534968-0a02-4591-a212-9bcea2647345
64d12d2a-f5a9-4109-b79f-561e15f878b6	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
c6ef708c-22a7-4dea-85a9-bfc2f5e63608	76de736c-3969-4979-8f1a-6a4afe6d8d7e
f2d14b9e-18a1-4479-a5da-835c7443586f	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
6a766343-b2eb-491f-8abb-ac90dd69fa95	b239d202-2b9d-44b5-9f94-a596fbcdf608
d9500d74-9405-4bb6-89b9-6b19147f2cc8	9704c250-2c29-4f49-a5dc-c3fface6a852
220672be-7563-4b84-83f0-cbd497765462	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
9623ff85-67b1-4f4d-8b48-1544c3cb38ab	21de695d-1881-42e4-a55a-488e7b9803cb
7575e78a-a78b-4900-9fb3-b30c925e5f89	3d534968-0a02-4591-a212-9bcea2647345
c02fcc25-b9f3-4473-bf1a-80abbdc73474	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
2bdba617-734f-48a5-844c-c7ca5a68781b	76de736c-3969-4979-8f1a-6a4afe6d8d7e
2bebe474-6406-409e-904c-ff7865ac755e	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
b0ed894a-610d-498c-b11f-ed47d2a87b29	b239d202-2b9d-44b5-9f94-a596fbcdf608
f927fc08-8f8a-4a0b-adec-d924091dcad1	9704c250-2c29-4f49-a5dc-c3fface6a852
4ac4c910-d783-48d5-ae41-b542e8cb666f	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
7472ab8a-901e-4dac-a330-9bbe4eda5a5a	21de695d-1881-42e4-a55a-488e7b9803cb
7d2d10ef-c751-4b4c-aff4-8f47c9952491	3d534968-0a02-4591-a212-9bcea2647345
c0cc7f72-bfb8-497c-8f42-3954aeb91b1c	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
f8c6500d-bbf6-4c88-959c-c67c7e572fc0	76de736c-3969-4979-8f1a-6a4afe6d8d7e
5d1b295d-a018-49a2-9c53-a639a3bf51ef	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
745820cf-14e3-4837-be8a-2f7151ec9131	b239d202-2b9d-44b5-9f94-a596fbcdf608
9e00a085-1e03-4bb5-b18d-65d93f16f743	9704c250-2c29-4f49-a5dc-c3fface6a852
57d296e1-7af7-4cfc-afd2-7bc6352a65e6	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
a96df0df-f4a1-4d82-a655-2f7f94ace896	21de695d-1881-42e4-a55a-488e7b9803cb
d1dbec9d-ce36-42b3-a467-0b1512f41545	3d534968-0a02-4591-a212-9bcea2647345
f3c04916-f30d-4360-b465-c5eb262dce94	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
76da11f5-10d2-4e79-af6d-1b92c4f2a0c0	76de736c-3969-4979-8f1a-6a4afe6d8d7e
3c7ad0b2-0f68-4e9d-b2a7-1219fee50785	b239d202-2b9d-44b5-9f94-a596fbcdf608
cd3675d5-61d6-4adf-96d8-bb5867342208	9704c250-2c29-4f49-a5dc-c3fface6a852
b0afe2ef-0b3d-481d-9654-f9e67207757d	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
a9b20768-6469-4d39-b0aa-c4ed19ae9897	21de695d-1881-42e4-a55a-488e7b9803cb
04b123c0-c2ed-464f-b848-5637bbd7d89d	3d534968-0a02-4591-a212-9bcea2647345
2bdf8bc5-7def-47aa-94ca-7f298307ab35	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
a96df0df-f4a1-4d82-a655-2f7f94ace896	9704c250-2c29-4f49-a5dc-c3fface6a852
d1dbec9d-ce36-42b3-a467-0b1512f41545	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
f3c04916-f30d-4360-b465-c5eb262dce94	21de695d-1881-42e4-a55a-488e7b9803cb
76da11f5-10d2-4e79-af6d-1b92c4f2a0c0	3d534968-0a02-4591-a212-9bcea2647345
960823cf-d908-4246-8fa0-0ac6118797ca	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
3c7ad0b2-0f68-4e9d-b2a7-1219fee50785	76de736c-3969-4979-8f1a-6a4afe6d8d7e
cd3675d5-61d6-4adf-96d8-bb5867342208	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
b0afe2ef-0b3d-481d-9654-f9e67207757d	b239d202-2b9d-44b5-9f94-a596fbcdf608
a9b20768-6469-4d39-b0aa-c4ed19ae9897	9704c250-2c29-4f49-a5dc-c3fface6a852
04b123c0-c2ed-464f-b848-5637bbd7d89d	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
2bdf8bc5-7def-47aa-94ca-7f298307ab35	21de695d-1881-42e4-a55a-488e7b9803cb
fcbe60a2-78a6-4f4c-951f-da6422cb80c3	3d534968-0a02-4591-a212-9bcea2647345
6f67e1b3-4b5b-4359-b7ea-583eebbfde21	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
693dab47-5108-490b-9a10-97ff75796112	76de736c-3969-4979-8f1a-6a4afe6d8d7e
645dce1e-7159-4b1b-86f0-0bc601f77b4a	b239d202-2b9d-44b5-9f94-a596fbcdf608
6a432d6d-6f5f-4d42-a364-efa8a1a9d1e1	9704c250-2c29-4f49-a5dc-c3fface6a852
16eca672-7fea-4e30-a715-4aaac96518ce	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
d1ec15b3-32ad-42af-b82b-32e4ccccca84	21de695d-1881-42e4-a55a-488e7b9803cb
0f6a77b3-b0c1-420a-943d-2ca4b161991d	3d534968-0a02-4591-a212-9bcea2647345
a82ca232-27f5-4edd-a1d8-4678f55e8c8b	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
64d12d2a-f5a9-4109-b79f-561e15f878b6	76de736c-3969-4979-8f1a-6a4afe6d8d7e
c6ef708c-22a7-4dea-85a9-bfc2f5e63608	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
f2d14b9e-18a1-4479-a5da-835c7443586f	b239d202-2b9d-44b5-9f94-a596fbcdf608
6a766343-b2eb-491f-8abb-ac90dd69fa95	9704c250-2c29-4f49-a5dc-c3fface6a852
d9500d74-9405-4bb6-89b9-6b19147f2cc8	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
220672be-7563-4b84-83f0-cbd497765462	21de695d-1881-42e4-a55a-488e7b9803cb
9623ff85-67b1-4f4d-8b48-1544c3cb38ab	3d534968-0a02-4591-a212-9bcea2647345
7575e78a-a78b-4900-9fb3-b30c925e5f89	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
c02fcc25-b9f3-4473-bf1a-80abbdc73474	76de736c-3969-4979-8f1a-6a4afe6d8d7e
2bdba617-734f-48a5-844c-c7ca5a68781b	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
2bebe474-6406-409e-904c-ff7865ac755e	b239d202-2b9d-44b5-9f94-a596fbcdf608
b0ed894a-610d-498c-b11f-ed47d2a87b29	9704c250-2c29-4f49-a5dc-c3fface6a852
f927fc08-8f8a-4a0b-adec-d924091dcad1	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
4ac4c910-d783-48d5-ae41-b542e8cb666f	21de695d-1881-42e4-a55a-488e7b9803cb
7472ab8a-901e-4dac-a330-9bbe4eda5a5a	3d534968-0a02-4591-a212-9bcea2647345
7d2d10ef-c751-4b4c-aff4-8f47c9952491	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
c0cc7f72-bfb8-497c-8f42-3954aeb91b1c	76de736c-3969-4979-8f1a-6a4afe6d8d7e
f8c6500d-bbf6-4c88-959c-c67c7e572fc0	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
5d1b295d-a018-49a2-9c53-a639a3bf51ef	b239d202-2b9d-44b5-9f94-a596fbcdf608
745820cf-14e3-4837-be8a-2f7151ec9131	9704c250-2c29-4f49-a5dc-c3fface6a852
9e00a085-1e03-4bb5-b18d-65d93f16f743	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
57d296e1-7af7-4cfc-afd2-7bc6352a65e6	21de695d-1881-42e4-a55a-488e7b9803cb
a96df0df-f4a1-4d82-a655-2f7f94ace896	3d534968-0a02-4591-a212-9bcea2647345
d1dbec9d-ce36-42b3-a467-0b1512f41545	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
f3c04916-f30d-4360-b465-c5eb262dce94	76de736c-3969-4979-8f1a-6a4afe6d8d7e
76da11f5-10d2-4e79-af6d-1b92c4f2a0c0	72ccf4fa-a557-4a29-ad3b-a2bc1c822253
960823cf-d908-4246-8fa0-0ac6118797ca	b239d202-2b9d-44b5-9f94-a596fbcdf608
3c7ad0b2-0f68-4e9d-b2a7-1219fee50785	9704c250-2c29-4f49-a5dc-c3fface6a852
cd3675d5-61d6-4adf-96d8-bb5867342208	f5bf0ba1-59b3-4ebf-8bf0-659482d81487
b0afe2ef-0b3d-481d-9654-f9e67207757d	21de695d-1881-42e4-a55a-488e7b9803cb
a9b20768-6469-4d39-b0aa-c4ed19ae9897	3d534968-0a02-4591-a212-9bcea2647345
04b123c0-c2ed-464f-b848-5637bbd7d89d	a1ca570a-9fa9-499a-8976-d5a1623d5cd8
f927fc08-8f8a-4a0b-adec-d924091dcad1	76de736c-3969-4979-8f1a-6a4afe6d8d7e
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: psql
--

COPY public.users ("userId", "userName", "firstName", "lastName", email, password, "avatarUrl", bio, "isVerified", "createdAt", "updatedAt") FROM stdin;
a96df0df-f4a1-4d82-a655-2f7f94ace896	User1@75	John	Doe	john.doe@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/1.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
d1dbec9d-ce36-42b3-a467-0b1512f41545	User2@75	Jane	Smith	jane.smith@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/2.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
f3c04916-f30d-4360-b465-c5eb262dce94	User3@75	Alice	Johnson	alice.johnson@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/3.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
76da11f5-10d2-4e79-af6d-1b92c4f2a0c0	User4@75	Bob	Brown	bob.brown@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/4.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
960823cf-d908-4246-8fa0-0ac6118797ca	User5@75	Charlie	Davis	charlie.davis@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/5.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
3c7ad0b2-0f68-4e9d-b2a7-1219fee50785	User6@75	David	Miller	david.miller@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/6.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
cd3675d5-61d6-4adf-96d8-bb5867342208	User7@75	Eve	Wilson	eve.wilson@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/7.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
b0afe2ef-0b3d-481d-9654-f9e67207757d	User8@75	Frank	Taylor	frank.taylor@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/8.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
a9b20768-6469-4d39-b0aa-c4ed19ae9897	User9@75	Grace	Anderson	grace.anderson@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/9.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
04b123c0-c2ed-464f-b848-5637bbd7d89d	User10@75	Henry	Thomas	henry.thomas@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/10.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
2bdf8bc5-7def-47aa-94ca-7f298307ab35	User11@75	Ivy	Martinez	ivy.martinez@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/11.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
6f67e1b3-4b5b-4359-b7ea-583eebbfde21	User14@75	Leo	Gonzalez	leo.gonzalez@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/14.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
693dab47-5108-490b-9a10-97ff75796112	User15@75	Mia	Wilson	mia.wilson@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/15.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
31c3d5b3-8c7c-4cef-a037-2eccb1839791	User16@75	Noah	Moore	noah.moore@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/16.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
645dce1e-7159-4b1b-86f0-0bc601f77b4a	User17@75	Olivia	Jackson	olivia.jackson@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/17.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
6a432d6d-6f5f-4d42-a364-efa8a1a9d1e1	User18@75	Paul	Lee	paul.lee@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/18.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
16eca672-7fea-4e30-a715-4aaac96518ce	User19@75	Quinn	Perez	quinn.perez@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/19.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
d1ec15b3-32ad-42af-b82b-32e4ccccca84	User20@75	Rachel	Hall	rachel.hall@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/20.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
0f6a77b3-b0c1-420a-943d-2ca4b161991d	User21@75	Steve	Young	steve.young@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/21.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
a82ca232-27f5-4edd-a1d8-4678f55e8c8b	User22@75	Tom	King	tom.king@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/22.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
64d12d2a-f5a9-4109-b79f-561e15f878b6	User23@75	Uma	Wright	uma.wright@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/23.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
c6ef708c-22a7-4dea-85a9-bfc2f5e63608	User24@75	Vera	Scott	vera.scott@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/24.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
f2d14b9e-18a1-4479-a5da-835c7443586f	User25@75	Will	Torres	will.torres@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/25.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
6a766343-b2eb-491f-8abb-ac90dd69fa95	User26@75	Xena	Evans	xena.evans@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/26.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
d9500d74-9405-4bb6-89b9-6b19147f2cc8	User27@75	Yara	Sanders	yara.sanders@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/27.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
220672be-7563-4b84-83f0-cbd497765462	User28@75	Zack	Morris	zack.morris@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/28.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
9623ff85-67b1-4f4d-8b48-1544c3cb38ab	User29@75	Amy	Reed	amy.reed@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/29.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
7575e78a-a78b-4900-9fb3-b30c925e5f89	User30@75	Brian	Cook	brian.cook@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/30.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
c02fcc25-b9f3-4473-bf1a-80abbdc73474	User31@75	Chloe	Morgan	chloe.morgan@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/31.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
2bdba617-734f-48a5-844c-c7ca5a68781b	User32@75	Dylan	Cox	dylan.cox@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/32.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
2bebe474-6406-409e-904c-ff7865ac755e	User33@75	Ella	Bailey	ella.bailey@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/33.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
b0ed894a-610d-498c-b11f-ed47d2a87b29	User34@75	Frank	Rivera	frank.rivera@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/34.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
f927fc08-8f8a-4a0b-adec-d924091dcad1	User35@75	Grace	Peterson	grace.peterson@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/35.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
4ac4c910-d783-48d5-ae41-b542e8cb666f	User36@75	Henry	Gray	henry.gray@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/36.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
7472ab8a-901e-4dac-a330-9bbe4eda5a5a	User37@75	Ivy	Ramirez	ivy.ramirez@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/37.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
7d2d10ef-c751-4b4c-aff4-8f47c9952491	User38@75	Jack	Martinez	jack.martinez@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/38.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
c0cc7f72-bfb8-497c-8f42-3954aeb91b1c	User39@75	Karen	Rodriguez	karen.rodriguez@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/39.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
f8c6500d-bbf6-4c88-959c-c67c7e572fc0	User40@75	Leo	Martinez	leo.martinez@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/40.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
5d1b295d-a018-49a2-9c53-a639a3bf51ef	User41@75	Mia	White	mia.white@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/41.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
745820cf-14e3-4837-be8a-2f7151ec9131	User42@75	Noah	Harris	noah.harris@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/42.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
9e00a085-1e03-4bb5-b18d-65d93f16f743	User43@75	Olivia	Clark	olivia.clark@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/women/43.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
57d296e1-7af7-4cfc-afd2-7bc6352a65e6	User44@75	Paul	Lewis	paul.lewis@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	randomuser.me/api/portraits/men/44.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
fcbe60a2-78a6-4f4c-951f-da6422cb80c3	User13@75	Karen	Lopez	karen.lopez@example.com	$2b$10$Y/dI5l3w5BIi63yXQ61KmO6c0ia8a1AsysKpr.JKXvwRR9wKfIiMq	localhost:3000/uploads/avatars/54697a9c-fb79-4979-97a6-0c7c580bfa8f.jpg		f	2024-06-21 18:21:05.522355	2024-06-21 18:21:05.522355
\.


--
-- Name: comment PK_1b03586f7af11eac99f4fdbf012; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT "PK_1b03586f7af11eac99f4fdbf012" PRIMARY KEY ("commentId");


--
-- Name: program-version PK_365be11da1c3512181c6e703b5c; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public."program-version"
    ADD CONSTRAINT "PK_365be11da1c3512181c6e703b5c" PRIMARY KEY ("programVersionId");


--
-- Name: program PK_4402716c9ca2c8e92092d118944; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT "PK_4402716c9ca2c8e92092d118944" PRIMARY KEY ("programId");


--
-- Name: group_programs PK_51bb98d9644d9fe4e1d5ae34b53; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.group_programs
    ADD CONSTRAINT "PK_51bb98d9644d9fe4e1d5ae34b53" PRIMARY KEY ("groupId", "programId");


--
-- Name: group PK_52a5b0126abd6ad70828290e822; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT "PK_52a5b0126abd6ad70828290e822" PRIMARY KEY ("groupId");


--
-- Name: follow PK_820ef916b8c67edfad7ea90ba0f; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT "PK_820ef916b8c67edfad7ea90ba0f" PRIMARY KEY ("relationId");


--
-- Name: reaction_entity PK_8afbbf659964bfe9f28a321de1e; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.reaction_entity
    ADD CONSTRAINT "PK_8afbbf659964bfe9f28a321de1e" PRIMARY KEY ("reactionId");


--
-- Name: users PK_8bf09ba754322ab9c22a215c919; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_8bf09ba754322ab9c22a215c919" PRIMARY KEY ("userId");


--
-- Name: program-versions PK_9e528c92c85a150c8835606bfde; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public."program-versions"
    ADD CONSTRAINT "PK_9e528c92c85a150c8835606bfde" PRIMARY KEY ("programVersionId");


--
-- Name: user PK_d72ea127f30e21753c9e229891e; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "PK_d72ea127f30e21753c9e229891e" PRIMARY KEY ("userId");


--
-- Name: user_groups PK_dc24675c437bf3c70d3d0dff67f; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT "PK_dc24675c437bf3c70d3d0dff67f" PRIMARY KEY ("userId", "groupId");


--
-- Name: program_version_entity PK_dd0cf15473d0ee84e318a55ff06; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.program_version_entity
    ADD CONSTRAINT "PK_dd0cf15473d0ee84e318a55ff06" PRIMARY KEY ("programVersionId");


--
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- Name: reaction_entity UQ_c2727d13e7c3be98dd491cbaebe; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.reaction_entity
    ADD CONSTRAINT "UQ_c2727d13e7c3be98dd491cbaebe" UNIQUE ("programId", "userId");


--
-- Name: user UQ_e12875dfb3b1d92d7d7c5377e22; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "UQ_e12875dfb3b1d92d7d7c5377e22" UNIQUE (email);


--
-- Name: IDX_4dcea3f5c6f04650517d9dc475; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX "IDX_4dcea3f5c6f04650517d9dc475" ON public.user_groups USING btree ("groupId");


--
-- Name: IDX_8a174f55a4ad2841e61d188505; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX "IDX_8a174f55a4ad2841e61d188505" ON public.group_programs USING btree ("groupId");


--
-- Name: IDX_97672ac88f789774dd47f7c8be; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX "IDX_97672ac88f789774dd47f7c8be" ON public.users USING btree (email);


--
-- Name: IDX_99d01ff7f143377c044f3d6c95; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX "IDX_99d01ff7f143377c044f3d6c95" ON public.user_groups USING btree ("userId");


--
-- Name: IDX_c6e7a84f75fe64cc348a54156f; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX "IDX_c6e7a84f75fe64cc348a54156f" ON public.group_programs USING btree ("programId");


--
-- Name: IDX_e12875dfb3b1d92d7d7c5377e2; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX "IDX_e12875dfb3b1d92d7d7c5377e2" ON public."user" USING btree (email);


--
-- Name: user_groups FK_4dcea3f5c6f04650517d9dc4750; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT "FK_4dcea3f5c6f04650517d9dc4750" FOREIGN KEY ("groupId") REFERENCES public."group"("groupId");


--
-- Name: follow FK_673eb90803096b4300d2f547a4c; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT "FK_673eb90803096b4300d2f547a4c" FOREIGN KEY ("followerUserId") REFERENCES public.users("userId");


--
-- Name: program-versions FK_73936ebfe47aae85cede55334e7; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public."program-versions"
    ADD CONSTRAINT "FK_73936ebfe47aae85cede55334e7" FOREIGN KEY ("programProgramId") REFERENCES public.program("programId");


--
-- Name: comment FK_73aac6035a70c5f0313c939f237; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT "FK_73aac6035a70c5f0313c939f237" FOREIGN KEY ("parentCommentId") REFERENCES public.comment("commentId") ON DELETE CASCADE;


--
-- Name: group_programs FK_8a174f55a4ad2841e61d1885050; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.group_programs
    ADD CONSTRAINT "FK_8a174f55a4ad2841e61d1885050" FOREIGN KEY ("groupId") REFERENCES public."group"("groupId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_groups FK_99d01ff7f143377c044f3d6c955; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT "FK_99d01ff7f143377c044f3d6c955" FOREIGN KEY ("userId") REFERENCES public.users("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: follow FK_a46b5b444603dfa4e356d8721b6; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT "FK_a46b5b444603dfa4e356d8721b6" FOREIGN KEY ("followingUserId") REFERENCES public.users("userId");


--
-- Name: comment FK_b4470bd83e8cf8a697761c9c974; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT "FK_b4470bd83e8cf8a697761c9c974" FOREIGN KEY ("programId") REFERENCES public.program("programId") ON DELETE CASCADE;


--
-- Name: program FK_bb38d80121a98937581cdd39f1b; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT "FK_bb38d80121a98937581cdd39f1b" FOREIGN KEY ("userUserId") REFERENCES public.users("userId");


--
-- Name: program-version FK_bd6a2bb7f5f823543f29debc9b6; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public."program-version"
    ADD CONSTRAINT "FK_bd6a2bb7f5f823543f29debc9b6" FOREIGN KEY ("programProgramId") REFERENCES public.program("programId") ON DELETE CASCADE;


--
-- Name: comment FK_c0354a9a009d3bb45a08655ce3b; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT "FK_c0354a9a009d3bb45a08655ce3b" FOREIGN KEY ("userId") REFERENCES public.users("userId");


--
-- Name: group_programs FK_c6e7a84f75fe64cc348a54156fe; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.group_programs
    ADD CONSTRAINT "FK_c6e7a84f75fe64cc348a54156fe" FOREIGN KEY ("programId") REFERENCES public.program("programId") ON DELETE CASCADE;


--
-- Name: group FK_d842262ed825467f5eefaa33c7a; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT "FK_d842262ed825467f5eefaa33c7a" FOREIGN KEY ("ownerUserId") REFERENCES public.users("userId");


--
-- Name: program_version_entity FK_e79400ba7dad5c8110e1d1fbbd8; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.program_version_entity
    ADD CONSTRAINT "FK_e79400ba7dad5c8110e1d1fbbd8" FOREIGN KEY ("programProgramId") REFERENCES public.program("programId");


--
-- Name: reaction_entity FK_e97b6649b2914160e8f502f8858; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.reaction_entity
    ADD CONSTRAINT "FK_e97b6649b2914160e8f502f8858" FOREIGN KEY ("programId") REFERENCES public.program("programId") ON DELETE CASCADE;


--
-- Name: reaction_entity FK_ec42c5a5dfd35f948b93cdf04f7; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.reaction_entity
    ADD CONSTRAINT "FK_ec42c5a5dfd35f948b93cdf04f7" FOREIGN KEY ("userId") REFERENCES public.users("userId");


--
-- PostgreSQL database dump complete
--

