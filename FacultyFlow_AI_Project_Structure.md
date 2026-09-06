# FacultyFlow AI

> **AI-powered academic assessment intelligence for university faculty**

## 1. Project Overview

FacultyFlow AI is an AI-powered assistant designed to help university
faculty members evaluate and improve academic assessments.

The system allows a faculty member to provide:

-   Course syllabus
-   Course Learning Outcomes (CLOs)
-   Current question paper
-   Previous question papers
-   Optional marking rubric

The AI analyzes these materials, compares them, identifies potential
issues, and provides actionable recommendations.

### Core Journey

**Faculty gives something → AI intelligently processes it → Faculty
receives something useful**

------------------------------------------------------------------------

# 2. Problem Statement

University faculty members spend significant time designing courses,
preparing examinations, checking assessment quality, comparing questions
with previous years, and maintaining consistent evaluation standards.

Common problems include:

-   Difficulty ensuring that an examination adequately covers the course
    and CLOs.
-   Repetition of questions from previous examinations.
-   Unbalanced distribution of topics and difficulty levels.
-   Difficulty determining whether questions measure the intended
    learning outcomes.
-   Differences in grading when multiple faculty members evaluate the
    same examination.
-   Time-consuming manual checking and comparison of academic documents.

### Our Focus

FacultyFlow AI focuses initially on **AI-powered assessment analysis**.

Instead of replacing the faculty member, the system acts as an
intelligent reviewer that helps the faculty member make better
assessment decisions.

------------------------------------------------------------------------

# 3. Main Objective

Build a system that answers:

> **"Before I publish this examination, what problems should I know
> about?"**

The AI should help faculty:

-   Understand assessment coverage
-   Compare current and previous examinations
-   Detect repeated or highly similar questions
-   Evaluate topic distribution
-   Analyze question difficulty
-   Map questions to CLOs
-   Identify missing or overrepresented areas
-   Recommend improvements

------------------------------------------------------------------------

# 4. Target Users

## Primary User

### University Faculty

A teacher preparing or reviewing an examination.

## Secondary Users

-   Course coordinators
-   Department heads
-   Examination committees
-   Academic quality assurance teams

------------------------------------------------------------------------

# 5. Core MVP

The MVP should focus on one strong workflow.

``` text
Upload Syllabus
      ↓
Upload CLOs
      ↓
Upload Previous Question Papers
      ↓
Upload Current Question Paper
      ↓
AI Processes Documents
      ↓
Assessment Analysis
      ↓
Problems & Recommendations
```

------------------------------------------------------------------------

# 6. Feature Set

## 6.1 Document Upload

Faculty can upload:

-   PDF
-   DOCX
-   TXT
-   Images of question papers

### Upload Categories

``` text
Course Information
├── Syllabus
└── CLOs

Previous Assessments
├── Midterm 2025
├── Final 2025
└── Midterm 2026

Current Assessment
└── Final 2026
```

------------------------------------------------------------------------

# 7. AI Assessment Analyzer

This is the **main feature**.

The AI extracts and analyzes:

-   Questions
-   Marks
-   Topics
-   CLOs
-   Difficulty
-   Cognitive level
-   Question similarity
-   Topic distribution

### Example

``` text
Question 1
Topic: Binary Search Tree
Marks: 5
CLO: CLO-2
Difficulty: Easy
Cognitive Level: Understand
```

------------------------------------------------------------------------

# 8. CLO Coverage Analysis

The AI determines how much of the examination evaluates each CLO.

### Example

  CLO       Coverage Status
  ------- ---------- ---------
  CLO-1          25% Good
  CLO-2          40% Good
  CLO-3           5% Warning
  CLO-4           0% Missing

### AI Recommendation

> CLO-4 is not currently assessed. Consider adding a question that
> evaluates this learning outcome.

------------------------------------------------------------------------

# 9. Topic Coverage Analysis

The system compares the examination against the syllabus.

### Example

``` text
Data Structures
████████████████ 40%

Trees
██████████       25%

Graphs
████             10%

Sorting
███               8%

Hashing
█                 3%
```

### AI Insight

> Hashing is significantly underrepresented compared with its presence
> in the course syllabus.

------------------------------------------------------------------------

# 10. Previous Question Similarity

The system compares current questions against previous examinations.

### Example

``` text
Current Question:
"Explain the working principle of a B-tree."

Previous Question:
"Describe how a B-tree works."

Similarity: 87%

Status: HIGH SIMILARITY
```

The system should show:

-   Similar question
-   Previous exam
-   Year
-   Similarity score
-   Reason for similarity

### Suggested Result

> This question is highly similar to a question used in the 2025 final
> examination.

------------------------------------------------------------------------

# 11. Question Quality Analysis

Each question receives an AI-generated analysis.

### Example

``` text
Question: Explain the working principle of a B-tree.

Topic:
Binary Trees

CLO:
CLO-2

Marks:
5

Difficulty:
Medium

Cognitive Level:
Understand

Previous Similarity:
87%

Status:
⚠️ Review Recommended
```

------------------------------------------------------------------------

# 12. Difficulty Distribution

The AI estimates the difficulty of questions.

### Example

``` text
Easy       30%
Medium     50%
Hard       20%
```

The system can warn if the assessment is heavily concentrated in one
difficulty level.

### Example Warning

> 75% of the examination is classified as Easy/Medium. Consider adding
> more higher-level analytical questions if appropriate for the course
> outcomes.

------------------------------------------------------------------------

# 13. Cognitive-Level Analysis

Questions can be categorized using levels such as:

-   Remember
-   Understand
-   Apply
-   Analyze
-   Evaluate
-   Create

### Example

  Level          Questions
  ------------ -----------
  Remember             20%
  Understand           30%
  Apply                25%
  Analyze              20%
  Evaluate              5%

The AI highlights whether the assessment is overly focused on simple
recall.

------------------------------------------------------------------------

# 14. Assessment Quality Score

Provide a simple overall score.

## Example

``` text
ASSESSMENT QUALITY

        78 / 100
```

### Breakdown

  Category                         Score
  ------------------------------ -------
  CLO Coverage                        82
  Topic Coverage                      75
  Difficulty Balance                  80
  Cognitive Balance                   74
  Question Diversity                  78
  Previous Question Similarity        70

> **Overall:** Good, but several areas should be reviewed before
> finalizing the examination.

------------------------------------------------------------------------

# 15. AI Recommendations

The AI should not simply identify problems.

It should suggest actions.

### Example

``` text
⚠️ Issue 1
CLO-4 has no assessment coverage.

Recommendation:
Add at least one question targeting CLO-4.

---

⚠️ Issue 2
Two questions are highly similar to previous examinations.

Recommendation:
Consider replacing one question with a different assessment of the same topic.

---

⚠️ Issue 3
Graph-related topics are underrepresented.

Recommendation:
Review whether the current distribution reflects the intended course coverage.
```

------------------------------------------------------------------------

# 16. Faculty AI Chat

A faculty member can ask questions about their uploaded assessment.

### Example Questions

``` text
Which CLO has the lowest coverage?

Which questions are similar to previous exams?

Is my exam balanced?

Which topics are missing?

Which questions are too easy?

Why did the assessment receive 78/100?

What should I improve before publishing this exam?
```

The AI should answer based on the uploaded academic documents.

------------------------------------------------------------------------

# 17. Grading Assistant --- Phase 2

This should be added only after the core assessment analyzer works.

Faculty can upload:

-   Question
-   Model answer
-   Rubric
-   Student answer

The AI assists with rubric-based evaluation.

### Example

``` text
Question: 10 marks

Rubric:
Concept       3
Explanation   3
Example       2
Accuracy      2

Student Score:
7 / 10

AI Explanation:
The student correctly explained the main concept
but missed an important part of the expected explanation.
```

------------------------------------------------------------------------

# 18. Multi-Faculty Grading Consistency --- Phase 2

If multiple faculty members grade the same answer:

``` text
Faculty A → 8/10
Faculty B → 6/10
Faculty C → 7/10
```

AI can identify a disagreement.

``` text
Expected range → 7–8

Status:
⚠️ Review Recommended
```

The goal is **not to automatically override the teachers**.

The AI highlights cases where faculty members may want to review the
grading together.

------------------------------------------------------------------------

# 19. Dashboard

## Home Screen

``` text
┌──────────────────────────────┐
│       FacultyFlow AI         │
│                              │
│  Recent Assessments           │
│                              │
│  Data Structures Final       │
│  Quality Score: 78/100       │
│                              │
│  Issues Found: 3             │
│                              │
│  [Analyze New Assessment]    │
└──────────────────────────────┘
```

------------------------------------------------------------------------

# 20. Assessment Report Screen

``` text
Assessment Quality
        78 / 100

CLO Coverage
        82%

Topic Coverage
        75%

Difficulty Balance
        80%

Question Similarity
        ⚠️ 3 Issues

Recommendations
        5
```

------------------------------------------------------------------------

# 21. Question Detail Screen

``` text
Question 4

"Explain the working principle of a B-tree."

Marks:
5

Topic:
Tree Data Structure

CLO:
CLO-2

Difficulty:
Medium

Cognitive Level:
Understand

Previous Similarity:
87%

⚠️ HIGH SIMILARITY

Similar Previous Question:
Final Examination 2025 — Q3

[View Recommendation]
```

------------------------------------------------------------------------

# 22. System Architecture

``` text
                 ┌─────────────────┐
                 │   Flutter App   │
                 │   Faculty UI    │
                 └────────┬────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │    Firebase     │
                 │ Authentication  │
                 │ Firestore       │
                 │ Storage         │
                 └────────┬────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │   AI Backend    │
                 │ Document Parser │
                 │ AI Model        │
                 │ Analysis Engine │
                 └────────┬────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │ Structured      │
                 │ Assessment      │
                 │ Report          │
                 └─────────────────┘
```

------------------------------------------------------------------------

# 23. Suggested Technology Stack

## Frontend

**Flutter**

Target:

-   Android
-   Optional Web

## Backend

**Firebase**

Use:

-   Firebase Authentication
-   Cloud Firestore
-   Firebase Storage
-   Cloud Functions if required

## AI

Use an LLM capable of:

-   Document understanding
-   Structured extraction
-   Reasoning
-   Classification
-   Similarity analysis

The exact AI provider can be selected based on the hackathon's available
APIs and quota.

------------------------------------------------------------------------

# 24. Data Model

## User

``` json
{
  "userId": "faculty_001",
  "name": "Faculty Name",
  "department": "CSE",
  "email": "faculty@example.com"
}
```

## Course

``` json
{
  "courseId": "CSE_2201",
  "courseName": "Data Structures",
  "department": "CSE",
  "semester": "Spring 2026"
}
```

## CLO

``` json
{
  "cloId": "CLO-1",
  "description": "Understand fundamental data structures"
}
```

## Assessment

``` json
{
  "assessmentId": "assessment_001",
  "courseId": "CSE_2201",
  "title": "Final Examination",
  "totalMarks": 100,
  "qualityScore": 78
}
```

## Question Analysis

``` json
{
  "questionId": "Q4",
  "text": "Explain the working principle of a B-tree.",
  "marks": 5,
  "topic": "B-tree",
  "clo": "CLO-2",
  "difficulty": "Medium",
  "cognitiveLevel": "Understand",
  "similarity": 0.87
}
```

------------------------------------------------------------------------

# 25. AI Processing Pipeline

``` text
Document Upload
      ↓
Text Extraction
      ↓
Document Classification
      ↓
Syllabus Analysis
      ↓
CLO Extraction
      ↓
Question Extraction
      ↓
Question Classification
      ↓
CLO Mapping
      ↓
Topic Mapping
      ↓
Difficulty Analysis
      ↓
Previous Question Comparison
      ↓
Quality Evaluation
      ↓
Recommendations
      ↓
Dashboard
```

------------------------------------------------------------------------

# 26. AI Output Format

The AI should return structured data rather than only plain text.

Example:

``` json
{
  "overallScore": 78,
  "cloCoverage": 82,
  "topicCoverage": 75,
  "difficultyBalance": 80,
  "issues": [
    {
      "type": "missing_clo",
      "severity": "high",
      "description": "CLO-4 is not assessed",
      "recommendation": "Add a question targeting CLO-4"
    },
    {
      "type": "similar_question",
      "severity": "medium",
      "question": "Q4",
      "similarity": 0.87
    }
  ]
}
```

------------------------------------------------------------------------

# 27. Important AI Design Principle

The AI should **assist, not decide**.

Instead of:

> "This examination is wrong."

Say:

> "This examination may require review because CLO-4 has no identified
> assessment coverage."

Instead of:

> "Give this student 7 marks."

Say:

> "Based on the provided rubric, the answer appears consistent with
> approximately 7/10. Faculty review is recommended."

This keeps the faculty member in control.

------------------------------------------------------------------------

# 28. MVP Priority

## Must Have

1.  Faculty login
2.  Course creation
3.  Document upload
4.  Syllabus/CLO extraction
5.  Question extraction
6.  CLO coverage
7.  Topic coverage
8.  Previous question similarity
9.  Difficulty analysis
10. Assessment quality score
11. Recommendations
12. Visual report

## Should Have

13. AI chat
14. Question detail view
15. Export report

## Could Have

16. AI grading
17. Rubric assistant
18. Multi-faculty grading comparison
19. Assessment history
20. Course-to-course comparison

------------------------------------------------------------------------

# 29. Hackathon Demo Flow

The entire demo should take approximately 3--5 minutes.

### Step 1 --- Problem

Show a faculty member preparing an examination manually.

> "How do I know whether my exam covers the CLOs, repeats previous
> questions, and maintains a balanced difficulty?"

### Step 2 --- Input

Upload:

``` text
Syllabus.pdf
CLO.pdf
Midterm_2025.pdf
Final_2025.pdf
Final_2026.pdf
```

### Step 3 --- AI Processing

Show:

``` text
Analyzing syllabus...
Extracting CLOs...
Reading questions...
Comparing previous examinations...
Evaluating assessment...
```

### Step 4 --- Result

Show:

``` text
Assessment Quality: 78/100

⚠️ 3 Issues Found

CLO-4 → Missing

Q4 → 87% similar to 2025 question

Graph Topics → Underrepresented
```

### Step 5 --- Recommendation

Show:

> "Before publishing this examination, consider adding an assessment for
> CLO-4 and reviewing Q4 due to its high similarity with a previous
> examination."

### Step 6 --- AI Chat

Ask:

> "Why did my exam receive 78?"

AI explains the score using the uploaded documents.

------------------------------------------------------------------------

# 30. What Makes This Different

FacultyFlow AI is not simply:

``` text
Teacher → AI → Generate Questions
```

It is:

``` text
Teacher
   ↓
Existing Academic Material
   ↓
AI Understands + Compares + Evaluates
   ↓
Finds Hidden Problems
   ↓
Explains Problems
   ↓
Recommends Improvements
   ↓
Faculty Makes Final Decision
```

The key value is **AI-assisted academic decision making**.

------------------------------------------------------------------------

# 31. Future Expansion

After the MVP, the platform can expand into:

-   Course design assistant
-   Syllabus quality checker
-   Curriculum overlap detection
-   AI rubric assistant
-   Grading consistency analysis
-   Academic document comparison
-   Course history
-   Assessment analytics
-   Faculty collaboration
-   Academic quality assurance

------------------------------------------------------------------------

# 32. One-Line Pitch

> **FacultyFlow AI helps university faculty review, compare, and improve
> examinations using AI---before those examinations reach students.**

------------------------------------------------------------------------

# 33. Short Pitch

> Faculty spend significant time manually reviewing examinations for CLO
> coverage, topic balance, difficulty, and repeated questions.
> FacultyFlow AI turns this into an intelligent workflow: upload the
> syllabus, CLOs, and previous/current examinations, and AI analyzes
> them to identify gaps, similarities, imbalances, and actionable
> improvements---while keeping the final decision with the faculty
> member.

------------------------------------------------------------------------

# 34. Project Success Criteria

The project succeeds if a judge can clearly understand:

``` text
PROBLEM
   ↓
Faculty struggle to review assessment quality

INPUT
   ↓
Syllabus + CLOs + Previous Exams + Current Exam

AI
   ↓
Extract + Compare + Evaluate + Detect + Recommend

RESULT
   ↓
Quality Score + Issues + Explanations + Recommendations
```

## Final Principle

> **Find a real problem. Build the smallest version that genuinely
> helps. Then make it yours.**
