Modular
=======

Overview
--------
Modular is a backend MVC framework for Dart that is currently in early development, 
however it is functional. Modular is a collection of packages consisting of routing, 
controllers and database connectivity (currently Neo4J). Whilst this is being 
developed, feel free to comment or take a peak at how this tries to tackle 
some development obstacles.

Modular utilises a dependency injection based architecture to prevent 'components' from
'depending' on another object/class.

For example, take the following code:


This is done to enforce that objects are 'valid' on instantiation/initialisation. Doing it 
this way helps to avoid classes needing to reference (and thus depend on) another, breaking
down modular design. Doing this via injection (thus outside the encapsulation of the class)
means components can work without depending on so many classes, and passes the information 
without needing to 'know' the class it is delivered from. 

The framework tries to abide by these rules, although sometimes it might be worse to do so 
(i.e. to do so would mean sometimes stripping out core language dependencies, and in some 
instances, injecting only 'primitive' like types would seem counter intuitive, 
even if it promotes modularity).

Installation
------------
