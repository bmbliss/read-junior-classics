# Read the Junior Classics App

An app to help parents, teachers and children read the junior classics. 

## Background and Motivation

The project stems from a personal experience with the Junior Classics book set, which provides a guided timeline for reading classic literature to children based on their grade level. I started with an paper version of this idea on my fridge to track which stories and poems have been read so far, a rating and a rough timeline to read them for each child based on their current grade. The goal is to digitize and expand upon this concept, creating a tool that helps parents and educators introduce children to classic literature in a structured, age-appropriate manner.

## App Goals and Value Proposition

1. Primary Goal: Encourage reading of classic literature, particularly the Junior Classics series.
2. Target Audience: Parents, teachers, and children.
3. Value Proposition: 
   - Provide a structured approach to reading classic literature.
   - Offer flexibility to accommodate various reading programs and personal preferences.
   - Track reading progress over extended periods (6-8 years).
   - Foster a community of readers sharing insights and recommendations.

## Key Features

1. Guided reading programs based on age/grade level.
2. Tracking of reading progress for multiple children.
3. Flexible system to accommodate various types of literary works (books, short stories, poems).
4. User-created and official reading lists and programs.
5. Rating and review system for literary works.
6. Tagging system for categorizing works across multiple dimensions.

## Architecture Overview

### Technology Stack
- Backend: Ruby on Rails
- Database: PostgreSQL (implied by the use of Rails)

### Core Entities

1. Users (parents/teachers)
2. Children/Students
3. Literary Works
4. Collections (e.g., Junior Classics volumes)
5. Programs/Schedules
6. Reading Entries (progress tracking)
7. Reviews/Ratings
8. Tags (with polymorphic associations)
9. Reading Lists

### Key Architectural Decisions

1. Flexible content model to handle both full books and shorter works.
2. Polymorphic tagging system for versatile categorization.
3. Separation of official and user-generated content (programs, reading lists).
4. Progress tracking linked to individual children rather than user accounts.

## Database Schema Highlights

- Polymorphic `taggings` table for flexible tagging across entities.
- `literary_works` table to represent various types of written content.
- `collections` table to group related literary works (e.g., Junior Classics volumes).
- `programs` and `program_items` tables to create structured reading plans.
- `reading_entries` table to track individual reading progress.

## Future Expansion Possibilities

1. Additional curated reading programs (e.g., "Great Books and Philosophy").
2. Expert-curated lists for different subjects.
3. Supplementary educational materials.
4. Community features like discussion forums.
5. Gamification elements (achievements/milestones).

## Development Philosophy

- Focus on encouraging reading rather than app engagement.
- Start with core functionality (Junior Classics guide) and expand gradually.
- Maintain flexibility to accommodate various types of reading programs and literature.
- Emphasize user experience for parents/teachers managing children's reading.

## Next Steps

1. Set up the basic Rails application structure.
2. Implement the core data models and associations.
3. Create the user interface for managing reading programs and tracking progress.
4. Develop import functionality for the Junior Classics data.
5. Implement the tagging system for flexible categorization.
6. Build basic user authentication and account management.

This summary encapsulates the key points of our discussion and provides a roadmap for developing the Reading Guide App.

(list of books and links to copies of them)[https://onlinebooks.library.upenn.edu/webbin/metabook?id=jrclassics]

## My TODO
- aggregate a rating average
- ability to rate a whole program and aggregate that average
- on the literary work show page, display the rating average and a few recent ratings and number of ratings? show if you read it already and any of your notes
- would it make sense to have comments for things? that could get out of hand...?
- improve the navigation, it is very clunky. link things together in a more cohesive way
- link to the literary works
- for public domain stuff, maybe provide the text? that could be a cool feature.
