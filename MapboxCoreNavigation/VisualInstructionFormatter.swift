import Foundation
import MapboxDirections

/**
 Formatter for creating visual instructions.
 */
@objc(MBVisualInstructionFormatter)
public class VisualInstructionFormatter: NSObject {
    
    let routeStepFormatter = RouteStepFormatter()
    
    /**
     Creates the optimal text to be displayed given a `RouteLeg` and `RouteStep`.
     */
    public func string(leg: RouteLeg?, step: RouteStep?) -> String? {
        if let currentLeg = leg, let destinationName = currentLeg.destination.name, let step = step, step.maneuverType == .arrive {
            return destinationName
        } else if let destinations = step?.destinations {
            return destinations.joined(separator: NSLocalizedString("DESTINATION_DELIMITER", bundle: .mapboxCoreNavigation, value: " / ", comment: "Delimiter between multiple destinations"))
        } else if let step = step, step.isNumberedMotorway, let codes = step.codes {
            return codes.joined(separator: NSLocalizedString("REF_DELIMITER", bundle: .mapboxCoreNavigation, value: " / ", comment: "Delimiter between route numbers in a road concurrency"))
        } else if let name = step?.names?.first {
            return name
        } else if let step = step {
            return routeStepFormatter.string(for: step)
        } else {
            return nil
        }
    }
    
    public func strings(leg: RouteLeg?, step: RouteStep?) -> (String?, String?) {
        if let currentLeg = leg, let destinationName = currentLeg.destination.name, let step = step, step.maneuverType == .arrive {
            return("You have arrived", destinationName)
        } else if let step = step, step.isNumberedMotorway, let codes = step.codes, let destinations = step.destinations {
            let primary = codes.joined(separator: NSLocalizedString("REF_DELIMITER", bundle: .mapboxCoreNavigation, value: " / ", comment: "Delimiter between route numbers in a road concurrency"))
            let secondary = destinations.joined(separator: NSLocalizedString("DESTINATION_DELIMITER", bundle: .mapboxCoreNavigation, value: " / ", comment: "Delimiter between multiple destinations"))
            return (primary, secondary)
        } else if let step = step, let names = step.names {
            let primary = names.first
            let secondary = names.suffix(from: 1).joined(separator: NSLocalizedString("DESTINATION_DELIMITER", bundle: .mapboxCoreNavigation, value: " / ", comment: "Delimiter between multiple destinations"))
            return (primary, secondary)
        } else if let currentLeg = leg, let destinationName = currentLeg.destination.name {
            return (destinationName, nil)
        }
        
        return (step?.instructions, nil)
    }
}
